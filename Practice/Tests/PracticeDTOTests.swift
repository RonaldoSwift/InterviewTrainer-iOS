import Foundation
import XCTest
@testable import Practice

final class PracticeDTOTests: XCTestCase {
    func testGenerateExamRequestEncodesBackendKeys() throws {
        let request = GenerateExamRequestDTO(
            topic: "Python",
            difficulty: "intermediate",
            language: "es"
        )

        let object = try jsonObject(from: JSONEncoder().encode(request))

        XCTAssertEqual(Set(object.keys), Set(["topic", "difficulty", "language"]))
        XCTAssertEqual(object["topic"] as? String, "Python")
        XCTAssertEqual(object["difficulty"] as? String, "intermediate")
        XCTAssertEqual(object["language"] as? String, "es")
    }

    func testGenerateExamResponseDecodesBackendPayload() throws {
        let data = Data(
            """
            {
              "exam_id": "exam-123",
              "topic": "Python",
              "difficulty": "intermediate",
              "language": "es",
              "questions": [
                {
                  "id": "q1",
                  "statement": "¿Qué es una lista en Python?",
                  "options": [
                    {
                      "id": "a",
                      "text": "Una colección ordenada y modificable"
                    },
                    {
                      "id": "b",
                      "text": "Un tipo de función"
                    }
                  ]
                }
              ]
            }
            """.utf8
        )

        let response = try JSONDecoder().decode(GenerateExamResponseDTO.self, from: data)

        XCTAssertEqual(response.examID, "exam-123")
        XCTAssertEqual(response.topic, "Python")
        XCTAssertEqual(response.difficulty, "intermediate")
        XCTAssertEqual(response.language, "es")
        XCTAssertEqual(response.questions.count, 1)
        XCTAssertEqual(response.questions[0].id, "q1")
        XCTAssertEqual(response.questions[0].statement, "¿Qué es una lista en Python?")
        XCTAssertEqual(response.questions[0].options.count, 2)
        XCTAssertEqual(response.questions[0].options[0].id, "a")
        XCTAssertEqual(
            response.questions[0].options[0].text,
            "Una colección ordenada y modificable"
        )
    }

    func testGenerateExamResponseEncodesSnakeCaseExamID() throws {
        let response = GenerateExamResponseDTO(
            examID: "exam-123",
            topic: "Python",
            difficulty: "intermediate",
            language: "es",
            questions: [
                QuestionResponseDTO(
                    id: "q1",
                    statement: "Question",
                    options: [AnswerOptionResponseDTO(id: "a", text: "Option")]
                ),
            ]
        )

        let object = try jsonObject(from: JSONEncoder().encode(response))

        XCTAssertEqual(object["exam_id"] as? String, "exam-123")
        XCTAssertNil(object["examID"])
    }

    func testSubmitExamRequestEncodesBackendKeys() throws {
        let request = SubmitExamRequestDTO(
            answers: [
                SubmittedAnswerDTO(questionID: "q1", selectedOptionID: "a"),
            ]
        )

        let object = try jsonObject(from: JSONEncoder().encode(request))
        let answers = try XCTUnwrap(object["answers"] as? [[String: String]])

        XCTAssertEqual(Set(object.keys), Set(["answers"]))
        XCTAssertEqual(
            answers,
            [["question_id": "q1", "selected_option_id": "a"]]
        )
    }

    func testExamResultResponseDecodesBackendPayload() throws {
        let data = Data(
            """
            {
              "exam_id": "exam-123",
              "score": 80.0,
              "total_questions": 5,
              "correct_answers": 4,
              "incorrect_answers": 1,
              "results": [
                {
                  "question_id": "q1",
                  "selected_option_id": "a",
                  "correct_option_id": "a",
                  "is_correct": true,
                  "explanation": "Una lista almacena elementos en orden y permite modificarlos."
                }
              ]
            }
            """.utf8
        )

        let response = try JSONDecoder().decode(ExamResultResponseDTO.self, from: data)

        XCTAssertEqual(response.examID, "exam-123")
        XCTAssertEqual(response.score, 80.0)
        XCTAssertEqual(response.totalQuestions, 5)
        XCTAssertEqual(response.correctAnswers, 4)
        XCTAssertEqual(response.incorrectAnswers, 1)
        XCTAssertEqual(response.results.count, 1)
        XCTAssertEqual(response.results[0].questionID, "q1")
        XCTAssertEqual(response.results[0].selectedOptionID, "a")
        XCTAssertEqual(response.results[0].correctOptionID, "a")
        XCTAssertTrue(response.results[0].isCorrect)
        XCTAssertEqual(
            response.results[0].explanation,
            "Una lista almacena elementos en orden y permite modificarlos."
        )
    }

    func testExamResultResponseEncodesSnakeCaseKeys() throws {
        let response = ExamResultResponseDTO(
            examID: "exam-123",
            score: 100,
            totalQuestions: 1,
            correctAnswers: 1,
            incorrectAnswers: 0,
            results: [
                QuestionResultResponseDTO(
                    questionID: "q1",
                    selectedOptionID: "a",
                    correctOptionID: "a",
                    isCorrect: true,
                    explanation: "Correct."
                ),
            ]
        )

        let object = try jsonObject(from: JSONEncoder().encode(response))
        let results = try XCTUnwrap(object["results"] as? [[String: Any]])
        let result = try XCTUnwrap(results.first)

        XCTAssertEqual(object["exam_id"] as? String, "exam-123")
        XCTAssertEqual(object["total_questions"] as? Int, 1)
        XCTAssertEqual(object["correct_answers"] as? Int, 1)
        XCTAssertEqual(object["incorrect_answers"] as? Int, 0)
        XCTAssertEqual(result["question_id"] as? String, "q1")
        XCTAssertEqual(result["selected_option_id"] as? String, "a")
        XCTAssertEqual(result["correct_option_id"] as? String, "a")
        XCTAssertEqual(result["is_correct"] as? Bool, true)
        XCTAssertNil(object["examID"])
        XCTAssertNil(result["questionID"])
    }

    private func jsonObject(from data: Data) throws -> [String: Any] {
        try XCTUnwrap(JSONSerialization.jsonObject(with: data) as? [String: Any])
    }
}
