import Foundation
import XCTest
@testable import Practice

final class ExamAPIServiceTests: XCTestCase {
    func testCheckHealthUsesHealthEndpoint() async throws {
        let (service, session) = makeService()
        defer {
            MockURLProtocol.reset()
            session.invalidateAndCancel()
        }
        MockURLProtocol.requestHandler = { request in
            try MockURLProtocol.response(for: request, json: #"{"status":"ok"}"#)
        }

        let response = try await service.checkHealth()

        XCTAssertEqual(MockURLProtocol.lastRequest?.httpMethod, "GET")
        XCTAssertEqual(MockURLProtocol.lastRequest?.url?.path, "/health")
        XCTAssertEqual(response.status, .ok)
    }

    func testCreateExamPostsUUIDAndMapsQuestions() async throws {
        let (service, session) = makeService()
        defer {
            MockURLProtocol.reset()
            session.invalidateAndCancel()
        }
        MockURLProtocol.requestHandler = { request in
            try MockURLProtocol.response(for: request, json: Self.examCreateJSON)
        }

        let response = try await service.createExam(
            CreateExamRequestDTO(
                examID: Self.examID,
                topic: "Swift",
                difficulty: "intermediate",
                language: "es"
            )
        )

        let request = try XCTUnwrap(MockURLProtocol.lastRequest)
        let body = try XCTUnwrap(MockURLProtocol.lastRequestBody)
        let json = try XCTUnwrap(JSONSerialization.jsonObject(with: body) as? [String: String])
        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(request.url?.path, "/exams")
        XCTAssertEqual(Set(json.keys), Set(["exam_id", "topic", "difficulty", "language"]))
        XCTAssertEqual(json["exam_id"], Self.examID.uuidString)
        XCTAssertEqual(json["topic"], "Swift")
        XCTAssertEqual(json["difficulty"], "intermediate")
        XCTAssertEqual(json["language"], "es")
        XCTAssertEqual(response.examID, Self.examID)
        XCTAssertEqual(response.questions.count, 5)
        XCTAssertEqual(response.questions[0].questionID, "q1")
        XCTAssertEqual(response.questions[0].text, "Question 1")
        XCTAssertEqual(response.questions[0].options[0].optionID, "a")
    }

    func testFetchExamUsesExamEndpointAndDecodesStatusAndAnswers() async throws {
        let (service, session) = makeService()
        defer {
            MockURLProtocol.reset()
            session.invalidateAndCancel()
        }
        MockURLProtocol.requestHandler = { request in
            try MockURLProtocol.response(for: request, json: Self.examReadJSON)
        }

        let response = try await service.fetchExam(examID: Self.examID)

        XCTAssertEqual(MockURLProtocol.lastRequest?.httpMethod, "GET")
        XCTAssertEqual(MockURLProtocol.lastRequest?.url?.path, "/exams/\(Self.examID.uuidString)")
        XCTAssertEqual(response.examID, Self.examID)
        XCTAssertEqual(response.status, .inProgress)
        XCTAssertEqual(response.questions.count, 5)
        XCTAssertEqual(response.answers.count, 1)
        XCTAssertEqual(response.answers[0].optionID, "a")
    }

    func testSubmitAnswerPostsOneAnswerAndDecodesItsResult() async throws {
        let (service, session) = makeService()
        defer {
            MockURLProtocol.reset()
            session.invalidateAndCancel()
        }
        MockURLProtocol.requestHandler = { request in
            try MockURLProtocol.response(for: request, json: Self.submitAnswerJSON)
        }

        let response = try await service.submitAnswer(
            examID: Self.examID,
            answer: AnswerRequestDTO(questionID: "q1", optionID: "b")
        )

        let request = try XCTUnwrap(MockURLProtocol.lastRequest)
        let body = try XCTUnwrap(MockURLProtocol.lastRequestBody)
        let json = try XCTUnwrap(JSONSerialization.jsonObject(with: body) as? [String: String])
        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(
            request.url?.path,
            "/exams/\(Self.examID.uuidString)/answers"
        )
        XCTAssertEqual(json, ["question_id": "q1", "option_id": "b"])
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

    func testFetchExamSummaryUsesSummaryEndpoint() async throws {
        let (service, session) = makeService()
        defer {
            MockURLProtocol.reset()
            session.invalidateAndCancel()
        }
        MockURLProtocol.requestHandler = { request in
            try MockURLProtocol.response(for: request, json: Self.examSummaryJSON)
        }

        let response = try await service.fetchExamSummary(examID: Self.examID)

        XCTAssertEqual(MockURLProtocol.lastRequest?.httpMethod, "GET")
        XCTAssertEqual(
            MockURLProtocol.lastRequest?.url?.path,
            "/exams/\(Self.examID.uuidString)/summary"
        )
        XCTAssertEqual(response.examID, Self.examID)
        XCTAssertEqual(response.status, .completed)
        XCTAssertEqual(response.totalQuestions, 5)
        XCTAssertEqual(response.answeredQuestions, 5)
        XCTAssertEqual(response.correctAnswers, 3)
        XCTAssertEqual(response.percentage, 60)
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
                json: #"{"code":"invalid_input","message":"Invalid request"}"#
            )
        }

        do {
            _ = try await service.fetchExamSummary(examID: Self.examID)
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

    private static let examID = UUID(uuidString: "d290f1ee-6c54-4b01-90e6-d701748f0851")!

    private static let questionsJSON = """
    [
      {"question_id":"q1","text":"Question 1","options":[
        {"option_id":"a","text":"A"},{"option_id":"b","text":"B"},
        {"option_id":"c","text":"C"},{"option_id":"d","text":"D"}
      ]},
      {"question_id":"q2","text":"Question 2","options":[
        {"option_id":"a","text":"A"},{"option_id":"b","text":"B"},
        {"option_id":"c","text":"C"},{"option_id":"d","text":"D"}
      ]},
      {"question_id":"q3","text":"Question 3","options":[
        {"option_id":"a","text":"A"},{"option_id":"b","text":"B"},
        {"option_id":"c","text":"C"},{"option_id":"d","text":"D"}
      ]},
      {"question_id":"q4","text":"Question 4","options":[
        {"option_id":"a","text":"A"},{"option_id":"b","text":"B"},
        {"option_id":"c","text":"C"},{"option_id":"d","text":"D"}
      ]},
      {"question_id":"q5","text":"Question 5","options":[
        {"option_id":"a","text":"A"},{"option_id":"b","text":"B"},
        {"option_id":"c","text":"C"},{"option_id":"d","text":"D"}
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
