struct ExamResultResponseDTO: Codable {
    let examID: String
    let score: Double
    let totalQuestions: Int
    let correctAnswers: Int
    let incorrectAnswers: Int
    let results: [QuestionResultResponseDTO]

    private enum CodingKeys: String, CodingKey {
        case examID = "exam_id"
        case score
        case totalQuestions = "total_questions"
        case correctAnswers = "correct_answers"
        case incorrectAnswers = "incorrect_answers"
        case results
    }
}
