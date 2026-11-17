

import Foundation

public struct ExamResultResponseDTO: Decodable {
    public let examId: String
    public let score: Int
    public let correctAnswers: Int
    public let incorrectAnswers: Int    
    public let totalQuestions: Int
    public let results: [QuestionResultDTO]

    enum CodingKeys: String, CodingKey {
        case examId = "exam_id"
        case score
        case correctAnswers = "correct_answers"
        case incorrectAnswers = "incorrect_answers"
        case totalQuestions = "total_questions"
        case results
    }
}