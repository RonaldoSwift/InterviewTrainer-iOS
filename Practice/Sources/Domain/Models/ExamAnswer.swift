public struct ExamAnswer: Equatable {
    public let questionID: String
    public let selectedOptionID: String

    public init(questionID: String, selectedOptionID: String) {
        self.questionID = questionID
        self.selectedOptionID = selectedOptionID
    }
}
