
//Cuando iOS solicite un examen, el backend devolverá algo parecido a esto:

/*
{
    "exam_id": "exam_001",
    "questions": [
        {
            "question_id": "question_001",
            "statement": "¿Qué es SwiftUI?",
            "code_snippet": null,
            "options": []
        }
    ]
}
*/

import Foundation

public struct ExamResponseDTO: Decodable {
    public let examId: String
    public let topic: ExamTopic
    public let difficulty: ExamDifficulty
    public let language: ExamLanguage
    public let totalQuestions: Int
    public let questions: [QuestionDTO]

    enum CodingKeys: String, CodingKey {
        case examId = "exam_id"
        case topic
        case difficulty
        case language
        case totalQuestions = "total_questions"
        case questions
    }
}