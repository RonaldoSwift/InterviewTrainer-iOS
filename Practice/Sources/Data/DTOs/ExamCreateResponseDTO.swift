import Foundation

struct ExamCreateResponseDTO: Codable {
    let examID: UUID
    let topic: String
    let difficulty: String
    let language: String
    let questions: [QuestionResponseDTO]

    private enum CodingKeys: String, CodingKey {
        case examID = "exam_id"
        case topic
        case difficulty
        case language
        case questions
    }
}
