
/*
Propiedad	Significado
id	Identificador local para SwiftUI.
examId	Identificador del examen generado por el backend.
topic	Tema seleccionado.
difficulty	Nivel de dificultad.
language	Idioma del examen.
questions	Lista de preguntas del examen.
*/

import Foundation

public struct Exam: Identifiable {
    public let id: UUID
    public let examId: String
    public let topic: ExamTopic
    public let difficulty: ExamDifficulty
    public let language: ExamLanguage
    public let questions: [Question]

    public init(
        id: UUID = UUID(),
        examId: String,
        topic: ExamTopic,
        difficulty: ExamDifficulty,
        language: ExamLanguage,
        questions: [Question]
    ) {
        self.id = id
        self.examId = examId
        self.topic = topic
        self.difficulty = difficulty
        self.language = language
        self.questions = questions
    }
}