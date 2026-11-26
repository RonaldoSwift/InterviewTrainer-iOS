import Combine
import Foundation

@MainActor
public final class PracticeViewModel: ObservableObject {
    enum Screen: Equatable {
        case configuration
        case exam
        case results
    }

    @Published var topic = ""
    @Published var difficulty = "intermediate"
    @Published var languageCode = "es"
    @Published private(set) var screen = Screen.configuration
    @Published private(set) var exam: Exam?
    @Published private(set) var examResult: ExamResult?
    @Published private(set) var currentQuestionIndex = 0
    @Published private(set) var selectedOptionIDs: [String: String] = [:]
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?

    private let apiService: ExamAPIService

    var canGenerate: Bool {
        !topic.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !isLoading
    }

    var currentQuestion: Question? {
        guard
            let exam,
            exam.questions.indices.contains(currentQuestionIndex)
        else {
            return nil
        }

        return exam.questions[currentQuestionIndex]
    }

    var isLastQuestion: Bool {
        guard let exam else {
            return false
        }

        return currentQuestionIndex == exam.questions.count - 1
    }

    var canSubmit: Bool {
        guard let exam, !exam.questions.isEmpty, !isLoading else {
            return false
        }

        return exam.questions.allSatisfy { selectedOptionIDs[$0.id] != nil }
    }

    public init() {
        apiService = ExamAPIService()
    }

    init(apiService: ExamAPIService) {
        self.apiService = apiService
    }

    func generateExam() async {
        guard canGenerate else {
            return
        }

        errorMessage = nil
        isLoading = true
        defer { isLoading = false }

        do {
            let generatedExam = try await apiService.generateExam(
                topic: topic.trimmingCharacters(in: .whitespacesAndNewlines),
                difficulty: difficulty,
                language: languageCode
            )
            exam = generatedExam
            examResult = nil
            currentQuestionIndex = 0
            selectedOptionIDs = [:]
            screen = .exam
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func selectOption(_ optionID: String) {
        guard
            let question = currentQuestion,
            question.options.contains(where: { $0.id == optionID })
        else {
            return
        }

        selectedOptionIDs[question.id] = optionID
    }

    func selectedOptionID(for questionID: String) -> String? {
        selectedOptionIDs[questionID]
    }

    func previousQuestion() {
        guard currentQuestionIndex > 0 else {
            return
        }

        currentQuestionIndex -= 1
    }

    func nextQuestion() {
        guard
            let exam,
            currentQuestionIndex < exam.questions.count - 1
        else {
            return
        }

        currentQuestionIndex += 1
    }

    func submitExam() async {
        guard let exam, canSubmit else {
            errorMessage = "Responde todas las preguntas antes de finalizar el examen."
            return
        }

        let answers = exam.questions.compactMap { question in
            selectedOptionIDs[question.id].map {
                ExamAnswer(questionID: question.id, selectedOptionID: $0)
            }
        }

        guard answers.count == exam.questions.count else {
            errorMessage = "No se pudieron preparar todas las respuestas del examen."
            return
        }

        errorMessage = nil
        isLoading = true
        defer { isLoading = false }

        do {
            try await apiService.submitExam(examID: exam.id, answers: answers)
            examResult = try await apiService.fetchExamResult(examID: exam.id)
            screen = .results
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func clearError() {
        errorMessage = nil
    }
}
