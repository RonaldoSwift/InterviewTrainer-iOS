
import Observation

@Observable
@MainActor
public final class PracticeSessionViewModel {

    public let exam: Exam

    public private(set) var currentQuestionIndex = 0
    public private(set) var selectedOptionId: String?
    public private(set) var isShowingFeedback = false
    public private(set) var isFinished = false

    public private(set) var correctAnswers = 0
    public private(set) var incorrectAnswers = 0

    public private(set) var currentFeedback: MockQuestionFeedback?

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
}
