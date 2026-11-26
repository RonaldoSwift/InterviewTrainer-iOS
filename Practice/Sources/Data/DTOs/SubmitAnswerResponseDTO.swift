import Foundation

struct SubmitAnswerResponseDTO: Codable {
    let questionID: String
    let optionID: String
    let isCorrect: Bool
    let correctOptionID: String
    let explanation: String
    let status: ExamStatusDTO
    let answeredQuestions: Int
    let totalQuestions: Int
    let progressPercentage: Double

    private enum CodingKeys: String, CodingKey {
        case questionID = "question_id"
        case optionID = "option_id"
        case isCorrect = "is_correct"
        case correctOptionID = "correct_option_id"
        case explanation
        case status
        case answeredQuestions = "answered_questions"
        case totalQuestions = "total_questions"
        case progressPercentage = "progress_percentage"
    }
}
