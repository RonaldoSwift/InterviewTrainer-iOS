
public struct MockQuestionFeedback {

    public let correctOptionId: String
    public let explanation: String

    public init(
        correctOptionId: String,
        explanation: String
    ) {
        self.correctOptionId = correctOptionId
        self.explanation = explanation
    }
}

public enum MockExamProvider {

    public static func makeExam(
        topic: ExamTopic,
        difficulty: ExamDifficulty,
        language: ExamLanguage
    ) -> Exam {

        let questions = [
            Question(
                questionId: "question-1",
                statement: "¿Qué es Swift?",
                options: [
                    AnswerOption(optionId: "A", text: "Un lenguaje de programación"),
                    AnswerOption(optionId: "B", text: "Una base de datos"),
                    AnswerOption(optionId: "C", text: "Un sistema operativo"),
                    AnswerOption(optionId: "D", text: "Un framework")
                ]
            ),
            Question(
                questionId: "question-2",
                statement: "¿Qué palabra clave declara una constante en Swift?",
                options: [
                    AnswerOption(optionId: "A", text: "var"),
                    AnswerOption(optionId: "B", text: "let"),
                    AnswerOption(optionId: "C", text: "const"),
                    AnswerOption(optionId: "D", text: "static")
                ]
            ),
            Question(
                questionId: "question-3",
                statement: "¿Qué estructura permite agrupar datos relacionados?",
                options: [
                    AnswerOption(optionId: "A", text: "class"),
                    AnswerOption(optionId: "B", text: "enum"),
                    AnswerOption(optionId: "C", text: "struct"),
                    AnswerOption(optionId: "D", text: "protocol")
                ]
            ),
            Question(
                questionId: "question-4",
                statement: "¿Qué tipo representa un valor que puede ser nulo?",
                options: [
                    AnswerOption(optionId: "A", text: "String"),
                    AnswerOption(optionId: "B", text: "Optional"),
                    AnswerOption(optionId: "C", text: "Int"),
                    AnswerOption(optionId: "D", text: "Bool")
                ]
            ),
            Question(
                questionId: "question-5",
                statement: "¿Qué palabra clave se utiliza para crear una instancia de una clase?",
                options: [
                    AnswerOption(optionId: "A", text: "create"),
                    AnswerOption(optionId: "B", text: "new"),
                    AnswerOption(optionId: "C", text: "init"),
                    AnswerOption(optionId: "D", text: "instance")
                ]
            )
        ]

        return Exam(
            examId: "mock-exam-001",
            topic: topic,
            difficulty: difficulty,
            language: language,
            questions: questions
        )
    }

    public static func feedback(
        for questionId: String
    ) -> MockQuestionFeedback? {

        switch questionId {
        case "question-1":
            return MockQuestionFeedback(
                correctOptionId: "A",
                explanation: "Swift es un lenguaje de programación desarrollado por Apple."

            )

        case "question-2":
            return MockQuestionFeedback(
                correctOptionId: "B",
                explanation: "La palabra let declara constantes, cuyos valores no pueden reasignarse."
            )

        case "question-3":
            return MockQuestionFeedback(
                correctOptionId: "C",
                explanation: "Una estructura (struct) permite agrupar propiedades y comportamientos."
            )

        case "question-4":
            return MockQuestionFeedback(
                correctOptionId: "B",
                explanation: "Optional permite representar un valor que puede contener un valor o nil."
            )

        case "question-5":
            return MockQuestionFeedback(
                correctOptionId: "C",
                explanation: "init es el inicializador utilizado para preparar una nueva instancia."
            )

        default:
            return nil
        }
    }
}
