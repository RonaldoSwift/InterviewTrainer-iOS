import Foundation

struct ExamSummaryResponseDTO: Codable {
    let examID: UUID
    let status: ExamStatusDTO
    let totalQuestions: Int
    let answeredQuestions: Int
    let correctAnswers: Int
    let percentage: Double

    private enum CodingKeys: String, CodingKey {
        case examID = "exam_id"
        case status
        case totalQuestions = "total_questions"
        case answeredQuestions = "answered_questions"
        case correctAnswers = "correct_answers"
        case percentage
    }
}
