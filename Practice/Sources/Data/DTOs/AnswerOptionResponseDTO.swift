struct AnswerOptionResponseDTO: Codable {
    let optionID: String
    let text: String

    private enum CodingKeys: String, CodingKey {
        case optionID = "option_id"
        case text
    }
}
