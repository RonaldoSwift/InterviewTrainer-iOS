import Foundation
import XCTest
@testable import Practice

final class PracticeDTOTests: XCTestCase {
    func testCreateExamRequestEncodesUUIDAndBackendKeys() throws {
        let request = CreateExamRequestDTO(
            examID: Self.examID,
            topic: "Swift",
            difficulty: "basic",
            language: "en"
        )

        let object = try jsonObject(from: JSONEncoder().encode(request))

        XCTAssertEqual(
            Set(object.keys),
            Set(["exam_id", "topic", "difficulty", "language"])
        )
        XCTAssertEqual(object["exam_id"], Self.examID.uuidString)
        XCTAssertEqual(object["topic"], "Swift")
        XCTAssertEqual(object["difficulty"], "basic")
        XCTAssertEqual(object["language"], "en")
    }

    func testExamCreateResponseDecodesBackendQuestionsAndOptions() throws {
        let response = try JSONDecoder().decode(
            ExamCreateResponseDTO.self,
            from: Data(Self.examCreateJSON.utf8)
        )

        XCTAssertEqual(response.examID, Self.examID)
        XCTAssertEqual(response.topic, "Swift")
        XCTAssertEqual(response.difficulty, "intermediate")
        XCTAssertEqual(response.language, "es")
        XCTAssertEqual(response.questions.count, 5)
        XCTAssertEqual(response.questions[0].questionID, "q1")
        XCTAssertEqual(response.questions[0].text, "Question 1")
        XCTAssertEqual(response.questions[0].options.count, 4)
        XCTAssertEqual(response.questions[0].options[0].optionID, "a")
        XCTAssertEqual(response.questions[0].options[0].text, "Option a")
    }

    func testAnswerRequestEncodesOneAnswerWithBackendKeys() throws {
        let request = AnswerRequestDTO(questionID: "q1", optionID: "b")

        let object = try jsonObject(from: JSONEncoder().encode(request))

        XCTAssertEqual(object, ["question_id": "q1", "option_id": "b"])
    }

    func testSubmitAnswerResponseDecodesCorrectionAndProgress() throws {
        let response = try JSONDecoder().decode(
            SubmitAnswerResponseDTO.self,
            from: Data(Self.submitAnswerJSON.utf8)
        )

        XCTAssertEqual(response.questionID, "q1")
        XCTAssertEqual(response.optionID, "b")
        XCTAssertFalse(response.isCorrect)
        XCTAssertEqual(response.correctOptionID, "a")
        XCTAssertEqual(response.explanation, "Option a is correct.")
        XCTAssertEqual(response.status, .inProgress)
        XCTAssertEqual(response.answeredQuestions, 1)
        XCTAssertEqual(response.totalQuestions, 5)
        XCTAssertEqual(response.progressPercentage, 20)
    }

    func testExamReadResponseDecodesStatusQuestionsAndRecordedAnswers() throws {
        let response = try JSONDecoder().decode(
            ExamReadResponseDTO.self,
            from: Data(Self.examReadJSON.utf8)
        )

        XCTAssertEqual(response.examID, Self.examID)
        XCTAssertEqual(response.status, .inProgress)
        XCTAssertEqual(response.questions.count, 5)
        XCTAssertEqual(response.questions[0].questionID, "q1")
        XCTAssertEqual(response.answers.count, 1)
        XCTAssertEqual(response.answers[0].questionID, "q1")
        XCTAssertEqual(response.answers[0].optionID, "a")
        XCTAssertTrue(response.answers[0].isCorrect)
    }

    func testExamSummaryResponseDecodesBackendFields() throws {
        let response = try JSONDecoder().decode(
            ExamSummaryResponseDTO.self,
            from: Data(Self.examSummaryJSON.utf8)
        )

        XCTAssertEqual(response.examID, Self.examID)
        XCTAssertEqual(response.status, .completed)
        XCTAssertEqual(response.totalQuestions, 5)
        XCTAssertEqual(response.answeredQuestions, 5)
        XCTAssertEqual(response.correctAnswers, 3)
        XCTAssertEqual(response.percentage, 60)
    }

    private func jsonObject(from data: Data) throws -> [String: String] {
        try XCTUnwrap(JSONSerialization.jsonObject(with: data) as? [String: String])
    }

    private static let examID = UUID(uuidString: "d290f1ee-6c54-4b01-90e6-d701748f0851")!

    private static let questionsJSON = """
    [
      {"question_id":"q1","text":"Question 1","options":[
        {"option_id":"a","text":"Option a"},{"option_id":"b","text":"Option b"},
        {"option_id":"c","text":"Option c"},{"option_id":"d","text":"Option d"}
      ]},
      {"question_id":"q2","text":"Question 2","options":[
        {"option_id":"a","text":"Option a"},{"option_id":"b","text":"Option b"},
        {"option_id":"c","text":"Option c"},{"option_id":"d","text":"Option d"}
      ]},
      {"question_id":"q3","text":"Question 3","options":[
        {"option_id":"a","text":"Option a"},{"option_id":"b","text":"Option b"},
        {"option_id":"c","text":"Option c"},{"option_id":"d","text":"Option d"}
      ]},
      {"question_id":"q4","text":"Question 4","options":[
        {"option_id":"a","text":"Option a"},{"option_id":"b","text":"Option b"},
        {"option_id":"c","text":"Option c"},{"option_id":"d","text":"Option d"}
      ]},
      {"question_id":"q5","text":"Question 5","options":[
        {"option_id":"a","text":"Option a"},{"option_id":"b","text":"Option b"},
        {"option_id":"c","text":"Option c"},{"option_id":"d","text":"Option d"}
      ]}
    ]
    """

    private static let examCreateJSON = """
    {
      "exam_id":"d290f1ee-6c54-4b01-90e6-d701748f0851",
      "topic":"Swift",
      "difficulty":"intermediate",
      "language":"es",
      "questions":\(questionsJSON)
    }
    """

    private static let submitAnswerJSON = """
    {
      "question_id":"q1",
      "option_id":"b",
      "is_correct":false,
      "correct_option_id":"a",
      "explanation":"Option a is correct.",
      "status":"in_progress",
      "answered_questions":1,
      "total_questions":5,
      "progress_percentage":20
    }
    """

    private static let examReadJSON = """
    {
      "exam_id":"d290f1ee-6c54-4b01-90e6-d701748f0851",
      "topic":"Swift",
      "difficulty":"intermediate",
      "language":"es",
      "status":"in_progress",
      "questions":\(questionsJSON),
      "answers":[
        {
          "question_id":"q1",
          "option_id":"a",
          "is_correct":true,
          "correct_option_id":"a",
          "explanation":"Option a is correct."
        }
      ]
    }
    """

    private static let examSummaryJSON = """
    {
      "exam_id":"d290f1ee-6c54-4b01-90e6-d701748f0851",
      "status":"completed",
      "total_questions":5,
      "answered_questions":5,
      "correct_answers":3,
      "percentage":60
    }
    """
}
