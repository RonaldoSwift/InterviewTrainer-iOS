struct QuestionResultResponseDTO: Codable {
    let questionID: String
    let selectedOptionID: String
    let correctOptionID: String
    let isCorrect: Bool
    let explanation: String

    private enum CodingKeys: String, CodingKey {
        case questionID = "question_id"
        case selectedOptionID = "selected_option_id"
        case correctOptionID = "correct_option_id"
        case isCorrect = "is_correct"
        case explanation
    }
}
