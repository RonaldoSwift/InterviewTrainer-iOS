import Foundation

struct ExamReadResponseDTO: Codable {
    let examID: UUID
    let topic: String
    let difficulty: String
    let language: String
    let status: ExamStatusDTO
    let questions: [QuestionResponseDTO]
    let answers: [AnswerResultDTO]

    private enum CodingKeys: String, CodingKey {
        case examID = "exam_id"
        case topic
        case difficulty
        case language
        case status
        case questions
        case answers
    }
}
