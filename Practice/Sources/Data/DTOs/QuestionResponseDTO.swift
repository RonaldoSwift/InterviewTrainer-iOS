struct QuestionResponseDTO: Codable {
    let questionID: String
    let text: String
    let options: [AnswerOptionResponseDTO]

    private enum CodingKeys: String, CodingKey {
        case questionID = "question_id"
        case text
        case options
    }
}
