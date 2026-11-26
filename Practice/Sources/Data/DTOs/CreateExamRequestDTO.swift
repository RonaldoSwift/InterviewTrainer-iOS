import Foundation

struct CreateExamRequestDTO: Codable {
    let examID: UUID
    let topic: String
    let difficulty: String
    let language: String

    private enum CodingKeys: String, CodingKey {
        case examID = "exam_id"
        case topic
        case difficulty
        case language
    }
}
