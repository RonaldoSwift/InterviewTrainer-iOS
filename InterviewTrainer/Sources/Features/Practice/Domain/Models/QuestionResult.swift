
/*
questionId	Identificador de la pregunta.
selectedOptionId	Alternativa seleccionada por el usuario.
correctOptionId	Alternativa correcta.
isCorrect	Indica si respondió correctamente.
explanation	Explicación de la respuesta.
codeExample	Ejemplo de código opcional.
*/

public struct QuestionResult {
    public let questionId: String
    public let selectedOptionId: String
    public let correctOptionId: String
    public let isCorrect: Bool
    public let explanation: String
    public let codeExample: String?

    public init(
        questionId: String,
        selectedOptionId: String,
        correctOptionId: String,
        isCorrect: Bool,
        explanation: String,
        codeExample: String? = nil
    ) {
        self.questionId = questionId
        self.selectedOptionId = selectedOptionId
        self.correctOptionId = correctOptionId
        self.isCorrect = isCorrect
        self.explanation = explanation
        self.codeExample = codeExample
    }
}