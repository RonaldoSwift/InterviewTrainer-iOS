public struct QuestionResult: Equatable {
    public let questionID: String
    public let selectedOptionID: String
    public let correctOptionID: String
    public let explanation: String

    public var isCorrect: Bool {
        selectedOptionID == correctOptionID
    }

    public init(
        questionID: String,
        selectedOptionID: String,
        correctOptionID: String,
        explanation: String
    ) {
        self.questionID = questionID
        self.selectedOptionID = selectedOptionID
        self.correctOptionID = correctOptionID
        self.explanation = explanation
    }
}
