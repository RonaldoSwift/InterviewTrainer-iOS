
/*Cuando el usuario quiera comenzar una práctica, iOS enviará un JSON parecido a este

{
    "topic": "swiftui",
    "difficulty": "intermediate",
    "language": "es",
    "total_questions": 5
}
*/

import Foundation

public struct GenerateExamRequestDTO: Encodable {
    public let topic: ExamTopic
    public let difficulty: ExamDifficulty
    public let language: ExamLanguage
    public let totalQuestions: Int

    enum CodingKeys: String, CodingKey {
        case topic
        case difficulty
        case language
        case totalQuestions = "total_questions"
    }

    public init(
        topic: ExamTopic,
        difficulty: ExamDifficulty,
        language: ExamLanguage,
        totalQuestions: Int = 5
    ) {
        self.topic = topic
        self.difficulty = difficulty
        self.language = language
        self.totalQuestions = totalQuestions
    }
}