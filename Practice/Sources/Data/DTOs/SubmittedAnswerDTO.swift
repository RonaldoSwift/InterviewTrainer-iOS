struct SubmittedAnswerDTO: Codable {
    let questionID: String
    let selectedOptionID: String

    private enum CodingKeys: String, CodingKey {
        case questionID = "question_id"
        case selectedOptionID = "selected_option_id"
    }
}
