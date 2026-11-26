import Foundation

struct AnswerRequestDTO: Codable {
    let questionID: String
    let optionID: String

    private enum CodingKeys: String, CodingKey {
        case questionID = "question_id"
        case optionID = "option_id"
    }
}
