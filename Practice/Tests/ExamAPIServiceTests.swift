import Foundation
import XCTest
@testable import Practice

final class ExamAPIServiceTests: XCTestCase {
    func testGenerateExamPostsRequestAndMapsResponse() async throws {
        let (service, session) = makeService()
        defer {
            MockURLProtocol.reset()
            session.invalidateAndCancel()
        }
        MockURLProtocol.requestHandler = { request in
            try MockURLProtocol.response(for: request, json: Self.generatedExamJSON)
        }

        let exam = try await service.generateExam(
            topic: "Python",
            difficulty: "intermediate",
            language: "es"
        )

        let request = try XCTUnwrap(MockURLProtocol.lastRequest)
        let body = try XCTUnwrap(MockURLProtocol.lastRequestBody)
        let json = try XCTUnwrap(JSONSerialization.jsonObject(with: body) as? [String: String])
        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(request.url?.path, "/api/v1/exams/generate")
        XCTAssertEqual(json["topic"], "Python")
        XCTAssertEqual(json["difficulty"], "intermediate")
        XCTAssertEqual(json["language"], "es")
        XCTAssertEqual(exam.id, "exam-123")
        XCTAssertEqual(exam.language, .spanish)
        XCTAssertEqual(exam.questions.first?.options.first?.text, "A list")
    }

    func testSubmitExamPostsAnswersWithBackendKeys() async throws {
        let (service, session) = makeService()
        defer {
            MockURLProtocol.reset()
            session.invalidateAndCancel()
        }
        MockURLProtocol.requestHandler = { request in
            try MockURLProtocol.response(for: request, json: Self.resultJSON)
        }

        try await service.submitExam(
            examID: "exam-123",
            answers: [ExamAnswer(questionID: "q1", selectedOptionID: "a")]
        )

        let request = try XCTUnwrap(MockURLProtocol.lastRequest)
        let body = try XCTUnwrap(MockURLProtocol.lastRequestBody)
        let json = try XCTUnwrap(JSONSerialization.jsonObject(with: body) as? [String: Any])
        let answers = try XCTUnwrap(json["answers"] as? [[String: String]])
        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(request.url?.path, "/api/v1/exams/exam-123/submit")
        XCTAssertEqual(answers, [["question_id": "q1", "selected_option_id": "a"]])
    }

    func testFetchExamResultGetsAndMapsResponse() async throws {
        let (service, session) = makeService()
        defer {
            MockURLProtocol.reset()
            session.invalidateAndCancel()
        }
        MockURLProtocol.requestHandler = { request in
            try MockURLProtocol.response(for: request, json: Self.resultJSON)
        }

        let result = try await service.fetchExamResult(examID: "exam-123")

        let request = try XCTUnwrap(MockURLProtocol.lastRequest)
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertEqual(request.url?.path, "/api/v1/exams/exam-123/result")
        XCTAssertEqual(result.examID, "exam-123")
        XCTAssertEqual(result.score, 100)
        XCTAssertEqual(result.totalQuestions, 1)
        XCTAssertEqual(result.correctAnswers, 1)
        XCTAssertEqual(result.incorrectAnswers, 0)
        XCTAssertTrue(result.results[0].isCorrect)
    }

    func testNonSuccessHTTPStatusIsReported() async throws {
        let (service, session) = makeService()
        defer {
            MockURLProtocol.reset()
            session.invalidateAndCancel()
        }
        MockURLProtocol.requestHandler = { request in
            try MockURLProtocol.response(
                for: request,
                statusCode: 422,
                json: #"{"detail":"Invalid request"}"#
            )
        }

        do {
            _ = try await service.generateExam(
                topic: "Python",
                difficulty: "intermediate",
                language: "es"
            )
            XCTFail("Expected an HTTP status error.")
        } catch let error as ExamAPIError {
            XCTAssertEqual(error, .httpStatus(422))
        }
    }

    private func makeService() -> (ExamAPIService, URLSession) {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: configuration)
        let baseURL = URL(string: "http://127.0.0.1:8000")!
        return (ExamAPIService(baseURL: baseURL, session: session), session)
    }

    private static let generatedExamJSON = """
    {
      "exam_id": "exam-123",
      "topic": "Python",
      "difficulty": "intermediate",
      "language": "es",
      "questions": [
        {
          "id": "q1",
          "statement": "What is a list?",
          "options": [
            {"id": "a", "text": "A list"},
            {"id": "b", "text": "A function"}
          ]
        }
      ]
    }
    """

    private static let resultJSON = """
    {
      "exam_id": "exam-123",
      "score": 100.0,
      "total_questions": 1,
      "correct_answers": 1,
      "incorrect_answers": 0,
      "results": [
        {
          "question_id": "q1",
          "selected_option_id": "a",
          "correct_option_id": "a",
          "is_correct": true,
          "explanation": "A list stores values."
        }
      ]
    }
    """
}
