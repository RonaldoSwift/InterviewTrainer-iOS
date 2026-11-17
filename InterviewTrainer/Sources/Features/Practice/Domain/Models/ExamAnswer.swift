
//Representa la respuesta seleccionada para una pregunta.

public struct ExamAnswer {
    public let questionId: String
    public let selectedOptionId: String

    public init(
        questionId: String,
        selectedOptionId: String
    ) {
        self.questionId = questionId
        self.selectedOptionId = selectedOptionId
    }
}