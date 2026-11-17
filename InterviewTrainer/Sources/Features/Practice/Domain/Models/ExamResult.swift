
/*
Propiedad	Significado
score	Puntaje obtenido.
correctAnswers	Cantidad de respuestas correctas.
incorrectAnswers	Cantidad de respuestas incorrectas.
totalQuestions	Total de preguntas evaluadas.
results	Detalle de cada pregunta evaluada.
*/

public struct ExamResult {
    public let examId: String
    public let score: Int
    public let correctAnswers: Int
    public let incorrectAnswers: Int
    public let totalQuestions: Int
    public let results: [QuestionResult]

    public init(
        examId: String,
        score: Int,
        correctAnswers: Int,
        incorrectAnswers: Int,
        totalQuestions: Int,
        results: [QuestionResult]
    ) {
        self.examId = examId
        self.score = score
        self.correctAnswers = correctAnswers
        self.incorrectAnswers = incorrectAnswers
        self.totalQuestions = totalQuestions
        self.results = results
    }
}