

public struct SubmitAnswersRequestDTO: Encodable {
    public let answers: [AnswerDTO]

    public init(answers: [AnswerDTO]) {
        self.answers = answers
    }
}

public struct AnswerDTO: Encodable {
    public let questionId: String
    public let selectedOptionId: String

    enum CodingKeys: String, CodingKey {
        case questionId = "question_id"
        case selectedOptionId = "selected_option_id"
    }

    public init(
        questionId: String,
        selectedOptionId: String
    ) {
        self.questionId = questionId
        self.selectedOptionId = selectedOptionId
    }
}