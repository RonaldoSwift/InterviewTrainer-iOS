

public struct QuestionResultDTO: Decodable {
    public let questionId: String
    public let selectedOptionId: String
    public let correctOptionId: String
    public let isCorrect: Bool
    public let explanation: String
    public let codeExample: String?

    enum CodingKeys: String, CodingKey {
        case questionId = "question_id"
        case selectedOptionId = "selected_option_id"
        case correctOptionId = "correct_option_id"
        case isCorrect = "is_correct"
        case explanation
        case codeExample = "code_example"
    }
}