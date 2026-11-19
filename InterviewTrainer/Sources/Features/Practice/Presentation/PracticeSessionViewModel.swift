
import Observation

@Observable
@MainActor
public final class PracticeSessionViewModel {

    public enum SessionState: Equatable {
        case empty
        case questionWithoutResponse
        case responseSelected
        case feedback
        case results
        case error
    }

    public let exam: Exam

    public private(set) var currentQuestionIndex = 0
    public private(set) var selectedOptionId: String?
    public private(set) var isShowingFeedback = false
    public private(set) var isFinished = false

    public private(set) var correctAnswers = 0
    public private(set) var incorrectAnswers = 0

    public private(set) var currentFeedback: MockQuestionFeedback?
    public private(set) var errorMessage: String?

    public init(exam: Exam) {
        self.exam = exam
    }

    public var currentQuestion: Question {
        exam.questions[currentQuestionIndex]
    }

    public var totalQuestions: Int {
        exam.questions.count
    }

    public var questionNumber: Int {
        currentQuestionIndex + 1
    }

    public var canSubmitAnswer: Bool {
        selectedOptionId != nil && !isShowingFeedback
    }

    public var state: SessionState {
        if exam.questions.isEmpty {
            return .empty
        }
        if errorMessage != nil {
            return .error
        }
        if isFinished {
            return .results
        }
        if isShowingFeedback {
            return .feedback
        }
        if selectedOptionId != nil {
            return .responseSelected
        }
        return .questionWithoutResponse
    }

    public func selectOption(_ optionId: String) {
        guard !isShowingFeedback else { return }

        guard currentQuestion.options.contains(where: {
            $0.optionId == optionId
        }) else {
            return
        }

        selectedOptionId = optionId
    }

    public func submitAnswer() {
        guard let selectedOptionId else { return }
        guard !isShowingFeedback else { return }

        guard let feedback = MockExamProvider.feedback(
            for: currentQuestion.questionId
        ) else {
            errorMessage = PracticeLocalization.feedbackError
            return
        }

        currentFeedback = feedback
        isShowingFeedback = true

        if selectedOptionId == feedback.correctOptionId {
            correctAnswers += 1
        } else {
            incorrectAnswers += 1
        }
    }

    public func nextQuestion() {
        guard isShowingFeedback else { return }

        if currentQuestionIndex + 1 < totalQuestions {
            currentQuestionIndex += 1
            selectedOptionId = nil
            currentFeedback = nil
            isShowingFeedback = false
        } else {
            isFinished = true
        }
    }

    public func retryFeedback() {
        guard errorMessage != nil else { return }
        errorMessage = nil
        submitAnswer()
    }
}
