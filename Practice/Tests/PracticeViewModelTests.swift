import Foundation
import XCTest
@testable import Practice

@MainActor
final class PracticeViewModelTests: XCTestCase {
    func testGenerationAndAnswerSelectionFlow() async throws {
        let (service, session) = makeService()
        defer {
            MockURLProtocol.reset()
            session.invalidateAndCancel()
        }
        MockURLProtocol.requestHandler = { request in
            try MockURLProtocol.response(for: request, json: Self.generatedExamJSON)
        }
        let viewModel = PracticeViewModel(apiService: service)
        viewModel.topic = "Swift"

        await viewModel.generateExam()

        XCTAssertEqual(viewModel.screen, .exam)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.exam?.questions.count, 5)

        viewModel.selectOption("b")
        for _ in 1..<5 {
            viewModel.nextQuestion()
            viewModel.selectOption("a")
        }
        for _ in 1..<5 {
            viewModel.previousQuestion()
        }

        XCTAssertEqual(viewModel.selectedOptionID(for: "q1"), "b")
        XCTAssertEqual(viewModel.currentQuestionIndex, 0)
        XCTAssertTrue(viewModel.canSubmit)
    }

    func testSubmitSendsAnswersThenLoadsExamAndSummary() async throws {
        let (service, session) = makeService()
        defer {
            MockURLProtocol.reset()
            session.invalidateAndCancel()
        }
        var answeredQuestions = 0
        MockURLProtocol.requestHandler = { request in
            switch (request.httpMethod, request.url?.path) {
            case ("POST", "/exams"):
                return try MockURLProtocol.response(for: request, json: Self.generatedExamJSON)
            case ("POST", let path) where path?.hasSuffix("/answers") == true:
                guard
                    let body = MockURLProtocol.lastRequestBody,
                    let answer = try JSONSerialization.jsonObject(with: body) as? [String: String],
                    let questionID = answer["question_id"],
                    let optionID = answer["option_id"]
                else {
                    throw URLError(.badServerResponse)
                }
                answeredQuestions += 1
                let result: [String: Any] = [
                    "question_id": questionID,
                    "option_id": optionID,
                    "is_correct": optionID == "a",
                    "correct_option_id": "a",
                    "explanation": "Option a is correct.",
                    "status": answeredQuestions == 5 ? "completed" : "in_progress",
                    "answered_questions": answeredQuestions,
                    "total_questions": 5,
                    "progress_percentage": answeredQuestions * 20,
                ]
                let data = try JSONSerialization.data(withJSONObject: result)
                guard let json = String(data: data, encoding: .utf8) else {
                    throw URLError(.cannotDecodeContentData)
                }
                return try MockURLProtocol.response(for: request, json: json)
            case ("GET", let path) where path?.hasSuffix("/summary") == true:
                return try MockURLProtocol.response(for: request, json: Self.summaryJSON)
            case ("GET", let path) where path?.hasPrefix("/exams/") == true:
                return try MockURLProtocol.response(for: request, json: Self.examReadJSON)
            default:
                throw URLError(.badURL)
            }
        }
        let viewModel = PracticeViewModel(apiService: service)
        viewModel.topic = "Swift"
        await viewModel.generateExam()
        viewModel.selectOption("a")
        for _ in 1..<5 {
            viewModel.nextQuestion()
            viewModel.selectOption("b")
        }

        await viewModel.submitExam()

        XCTAssertEqual(viewModel.screen, .results)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.examResult?.totalQuestions, 5)
        XCTAssertEqual(viewModel.examResult?.correctAnswers, 1)
        XCTAssertEqual(viewModel.examResult?.incorrectAnswers, 4)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertEqual(answeredQuestions, 5)
        XCTAssertEqual(
            MockURLProtocol.lastRequest?.url?.path,
            "/exams/\(Self.examID.uuidString)/summary"
        )
    }

    func testGenerationHTTPErrorIsShownAndLoadingResets() async {
        let (service, session) = makeService()
        defer {
            MockURLProtocol.reset()
            session.invalidateAndCancel()
        }
        MockURLProtocol.requestHandler = { request in
            try MockURLProtocol.response(
                for: request,
                statusCode: 422,
                json: #"{"code":"invalid_input","message":"El idioma no es válido."}"#
            )
        }
        let viewModel = PracticeViewModel(apiService: service)
        viewModel.topic = "Swift"

        await viewModel.generateExam()

        XCTAssertEqual(viewModel.screen, .configuration)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertTrue(viewModel.errorMessage?.contains("422") == true)
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
      {"question_id":"q1","text":"First question","options":[
        {"option_id":"a","text":"First answer"},{"option_id":"b","text":"Second answer"},
        {"option_id":"c","text":"Third answer"},{"option_id":"d","text":"Fourth answer"}
      ]},
      {"question_id":"q2","text":"Second question","options":[
        {"option_id":"a","text":"First answer"},{"option_id":"b","text":"Second answer"},
        {"option_id":"c","text":"Third answer"},{"option_id":"d","text":"Fourth answer"}
      ]},
      {"question_id":"q3","text":"Third question","options":[
        {"option_id":"a","text":"First answer"},{"option_id":"b","text":"Second answer"},
        {"option_id":"c","text":"Third answer"},{"option_id":"d","text":"Fourth answer"}
      ]},
      {"question_id":"q4","text":"Fourth question","options":[
        {"option_id":"a","text":"First answer"},{"option_id":"b","text":"Second answer"},
        {"option_id":"c","text":"Third answer"},{"option_id":"d","text":"Fourth answer"}
      ]},
      {"question_id":"q5","text":"Fifth question","options":[
        {"option_id":"a","text":"First answer"},{"option_id":"b","text":"Second answer"},
        {"option_id":"c","text":"Third answer"},{"option_id":"d","text":"Fourth answer"}
      ]}
    ]
    """

    private static let generatedExamJSON = """
    {
      "exam_id": "d290f1ee-6c54-4b01-90e6-d701748f0851",
      "topic": "Swift",
      "difficulty": "intermediate",
      "language": "es",
      "questions":\(questionsJSON)
    }
    """

    private static let examReadJSON = """
    {
      "exam_id": "d290f1ee-6c54-4b01-90e6-d701748f0851",
      "topic": "Swift",
      "difficulty": "intermediate",
      "language": "es",
      "status": "completed",
      "questions":\(questionsJSON),
      "answers": [
        {
          "question_id": "q1",
          "option_id": "a",
          "is_correct": true,
          "correct_option_id": "a",
          "explanation": "First answer is correct."
        },
        {
          "question_id": "q2",
          "option_id": "b",
          "is_correct": false,
          "correct_option_id": "a",
          "explanation": "First answer is correct."
        },
        {
          "question_id": "q3",
          "option_id": "b",
          "is_correct": false,
          "correct_option_id": "a",
          "explanation": "First answer is correct."
        },
        {
          "question_id": "q4",
          "option_id": "b",
          "is_correct": false,
          "correct_option_id": "a",
          "explanation": "First answer is correct."
        },
        {
          "question_id": "q5",
          "option_id": "b",
          "is_correct": false,
          "correct_option_id": "a",
          "explanation": "First answer is correct."
        }
      ]
    }
    """

    private static let summaryJSON = """
    {
      "exam_id": "d290f1ee-6c54-4b01-90e6-d701748f0851",
      "status": "completed",
      "total_questions": 5,
      "answered_questions": 5,
      "correct_answers": 1,
      "percentage": 20
    }
    """
}
