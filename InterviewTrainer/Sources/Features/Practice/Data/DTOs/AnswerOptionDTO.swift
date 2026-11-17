

public struct AnswerOptionDTO: Decodable {
    public let optionId: String
    public let text: String

    enum CodingKeys: String, CodingKey {
        case optionId = "option_id"
        case text
    }
}