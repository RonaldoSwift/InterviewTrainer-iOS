import Foundation

enum ExamAPIError: Error, Equatable, LocalizedError {
    case invalidResponse
    case httpStatus(Int)
    case unsupportedLanguage(String)
    case inconsistentResult

    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "El backend devolvió una respuesta inválida."
        case let .httpStatus(statusCode):
            return "El backend respondió con el estado HTTP \(statusCode)."
        case let .unsupportedLanguage(language):
            return "El backend devolvió un idioma no compatible: \(language)."
        case .inconsistentResult:
            return "El backend devolvió resultados inconsistentes."
        }
    }
}

final class ExamAPIService {
    private let baseURL: URL
    private let session: URLSession

    init(baseURL: URL = APIConfiguration.baseURL, session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session
    }

    func generateExam(topic: String, difficulty: String, language: String) async throws -> Exam {
        let body = try JSONEncoder().encode(
            GenerateExamRequestDTO(
                topic: topic,
                difficulty: difficulty,
                language: language
            )
        )
        let request = makeRequest(
            path: ["api", "v1", "exams", "generate"],
            method: "POST",
            body: body
        )
        let response: GenerateExamResponseDTO = try await send(request)

        return try mapExam(response)
    }

    func submitExam(examID: String, answers: [ExamAnswer]) async throws {
        let body = try JSONEncoder().encode(
            SubmitExamRequestDTO(
                answers: answers.map {
                    SubmittedAnswerDTO(
                        questionID: $0.questionID,
                        selectedOptionID: $0.selectedOptionID
                    )
                }
            )
        )
        let request = makeRequest(
            path: ["api", "v1", "exams", examID, "submit"],
            method: "POST",
            body: body
        )
        let response: ExamResultResponseDTO = try await send(request)
        _ = try mapResult(response)
    }

    func fetchExamResult(examID: String) async throws -> ExamResult {
        let request = makeRequest(
            path: ["api", "v1", "exams", examID, "result"],
            method: "GET"
        )
        let response: ExamResultResponseDTO = try await send(request)

        return try mapResult(response)
    }

    private func makeRequest(path: [String], method: String, body: Data? = nil) -> URLRequest {
        let url = path.reduce(baseURL) { $0.appendingPathComponent($1) }
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body
        return request
    }

    private func send<Response: Decodable>(_ request: URLRequest) async throws -> Response {
        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw ExamAPIError.invalidResponse
        }
        guard (200..<300).contains(httpResponse.statusCode) else {
            throw ExamAPIError.httpStatus(httpResponse.statusCode)
        }

        return try JSONDecoder().decode(Response.self, from: data)
    }

    private func mapExam(_ response: GenerateExamResponseDTO) throws -> Exam {
        Exam(
            id: response.examID,
            topic: response.topic,
            difficulty: response.difficulty,
            language: try mapLanguage(response.language),
            questions: response.questions.map { question in
                Question(
                    id: question.id,
                    statement: question.statement,
                    options: question.options.map {
                        AnswerOption(id: $0.id, text: $0.text)
                    }
                )
            }
        )
    }

    private func mapResult(_ response: ExamResultResponseDTO) throws -> ExamResult {
        let questionResults = response.results.map {
            QuestionResult(
                questionID: $0.questionID,
                selectedOptionID: $0.selectedOptionID,
                correctOptionID: $0.correctOptionID,
                explanation: $0.explanation
            )
        }
        let result = ExamResult(
            examID: response.examID,
            score: response.score,
            results: questionResults
        )

        guard
            result.totalQuestions == response.totalQuestions,
            result.correctAnswers == response.correctAnswers,
            result.incorrectAnswers == response.incorrectAnswers
        else {
            throw ExamAPIError.inconsistentResult
        }

        for (dto, domainResult) in zip(response.results, questionResults) {
            guard dto.isCorrect == domainResult.isCorrect else {
                throw ExamAPIError.inconsistentResult
            }
        }

        return result
    }

    private func mapLanguage(_ language: String) throws -> ExamLanguage {
        let normalizedLanguage = language
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
        let languageIdentifier = normalizedLanguage
            .split(separator: "-", maxSplits: 1)
            .first
            .map(String.init) ?? normalizedLanguage

        switch languageIdentifier {
        case "es", "español", "spanish":
            return .spanish
        case "en", "english", "inglés":
            return .english
        default:
            throw ExamAPIError.unsupportedLanguage(language)
        }
    }
}
