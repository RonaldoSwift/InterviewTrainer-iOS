import Foundation

struct AnswerResultDTO: Codable {
    let questionID: String
    let optionID: String
    let isCorrect: Bool
    let correctOptionID: String
    let explanation: String

    private enum CodingKeys: String, CodingKey {
        case questionID = "question_id"
        case optionID = "option_id"
        case isCorrect = "is_correct"
        case correctOptionID = "correct_option_id"
        case explanation
    }
}
