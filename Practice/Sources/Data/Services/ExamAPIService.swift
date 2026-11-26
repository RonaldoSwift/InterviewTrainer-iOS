import Foundation

enum ExamAPIError: Error, Equatable, LocalizedError {
    case invalidResponse
    case invalidExamID(String)
    case httpStatus(Int)
    case unsupportedLanguage(String)
    case inconsistentResult

    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "El backend devolvió una respuesta inválida."
        case let .invalidExamID(examID):
            return "El identificador del examen no es un UUID válido: \(examID)."
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

    func checkHealth() async throws -> HealthResponseDTO {
        let request = makeRequest(path: ["health"], method: "GET")
        return try await send(request)
    }

    func createExam(_ body: CreateExamRequestDTO) async throws -> ExamCreateResponseDTO {
        let encodedBody = try JSONEncoder().encode(body)
        let request = makeRequest(path: ["exams"], method: "POST", body: encodedBody)
        return try await send(request)
    }

    func fetchExam(examID: UUID) async throws -> ExamReadResponseDTO {
        let request = makeRequest(path: ["exams", examID.uuidString], method: "GET")
        return try await send(request)
    }

    func submitAnswer(
        examID: UUID,
        answer: AnswerRequestDTO
    ) async throws -> SubmitAnswerResponseDTO {
        let body = try JSONEncoder().encode(answer)
        let request = makeRequest(
            path: ["exams", examID.uuidString, "answers"],
            method: "POST",
            body: body
        )
        return try await send(request)
    }

    func fetchExamSummary(examID: UUID) async throws -> ExamSummaryResponseDTO {
        let request = makeRequest(
            path: ["exams", examID.uuidString, "summary"],
            method: "GET"
        )
        return try await send(request)
    }

    func generateExam(topic: String, difficulty: String, language: String) async throws -> Exam {
        let response = try await createExam(
            CreateExamRequestDTO(
                examID: UUID(),
                topic: topic,
                difficulty: difficulty,
                language: language
            )
        )

        return try mapExam(response)
    }

    func submitExam(examID: String, answers: [ExamAnswer]) async throws {
        let id = try parseExamID(examID)
        for answer in answers {
            _ = try await submitAnswer(
                examID: id,
                answer: AnswerRequestDTO(
                    questionID: answer.questionID,
                    optionID: answer.selectedOptionID
                )
            )
        }
    }

    func fetchExamResult(examID: String) async throws -> ExamResult {
        let id = try parseExamID(examID)
        let exam = try await fetchExam(examID: id)
        let summary = try await fetchExamSummary(examID: id)
        let questionIDs = Set(exam.questions.map(\.questionID))
        let answeredQuestionIDs = Set(exam.answers.map(\.questionID))

        guard
            exam.examID == id,
            summary.examID == id,
            summary.status == .completed,
            summary.totalQuestions == exam.questions.count,
            summary.answeredQuestions == summary.totalQuestions,
            exam.answers.count == summary.answeredQuestions,
            questionIDs.count == exam.questions.count,
            answeredQuestionIDs.count == exam.answers.count,
            answeredQuestionIDs == questionIDs,
            exam.answers.allSatisfy({
                $0.isCorrect == ($0.optionID == $0.correctOptionID)
            })
        else {
            throw ExamAPIError.inconsistentResult
        }

        let results = exam.answers.map {
            QuestionResult(
                questionID: $0.questionID,
                selectedOptionID: $0.optionID,
                correctOptionID: $0.correctOptionID,
                explanation: $0.explanation
            )
        }
        let result = ExamResult(
            examID: exam.examID.uuidString,
            score: summary.percentage,
            results: results
        )

        guard result.correctAnswers == summary.correctAnswers else {
            throw ExamAPIError.inconsistentResult
        }

        return result
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

    private func mapExam(_ response: ExamCreateResponseDTO) throws -> Exam {
        Exam(
            id: response.examID.uuidString,
            topic: response.topic,
            difficulty: response.difficulty,
            language: try mapLanguage(response.language),
            questions: response.questions.map { question in
                Question(
                    id: question.questionID,
                    statement: question.text,
                    options: question.options.map {
                        AnswerOption(id: $0.optionID, text: $0.text)
                    }
                )
            }
        )
    }

    private func parseExamID(_ value: String) throws -> UUID {
        guard let examID = UUID(uuidString: value) else {
            throw ExamAPIError.invalidExamID(value)
        }
        return examID
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
