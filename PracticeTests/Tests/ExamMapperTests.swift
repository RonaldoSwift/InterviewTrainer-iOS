
import XCTest
@testable import Practice

final class ExamMapperTests: XCTestCase {

    func testToDomainMapsExamResponseCorrectly() {

        // Arrange: preparamos los datos de entrada.
        let option1 = AnswerOptionDTO(
            optionId: "A",
            text: "Swift es un lenguaje compilado."
        )

        let option2 = AnswerOptionDTO(
            optionId: "B",
            text: "Swift es un lenguaje interpretado."
        )

        let question = QuestionDTO(
            questionId: "question-1",
            statement: "¿Qué es Swift?",
            codeSnippet: nil,
            options: [option1, option2]
        )

        let dto = ExamResponseDTO(
            examId: "exam-123",
            topic: .swift,
            difficulty: .beginner,
            language: .spanish,
            totalQuestions: 1,
            questions: [question]
        )

        // Act: ejecutamos el mapper.
        let exam = ExamMapper.toDomain(from: dto)

        // Assert: verificamos el resultado.
        XCTAssertEqual(exam.examId, "exam-123")
        XCTAssertEqual(exam.topic, .swift)
        XCTAssertEqual(exam.difficulty, .beginner)
        XCTAssertEqual(exam.language, .spanish)
        XCTAssertEqual(exam.questions.count, 1)

        XCTAssertEqual(
            exam.questions[0].questionId,
            "question-1"
        )

        XCTAssertEqual(
            exam.questions[0].options.count,
            2
        )

        XCTAssertEqual(
            exam.questions[0].options[0].optionId,
            "A"
        )
    }
}
