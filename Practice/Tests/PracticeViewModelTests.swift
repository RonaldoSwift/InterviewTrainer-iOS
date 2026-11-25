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
        XCTAssertEqual(viewModel.exam?.questions.count, 2)

        viewModel.selectOption("b")
        viewModel.nextQuestion()
        viewModel.selectOption("a")
        viewModel.previousQuestion()

        XCTAssertEqual(viewModel.selectedOptionID(for: "q1"), "b")
        XCTAssertEqual(viewModel.currentQuestionIndex, 0)
        XCTAssertTrue(viewModel.canSubmit)
    }

    func testSubmitSendsAnswersThenLoadsResultEndpoint() async throws {
        let (service, session) = makeService()
        defer {
            MockURLProtocol.reset()
            session.invalidateAndCancel()
        }
        MockURLProtocol.requestHandler = { request in
            switch (request.httpMethod, request.url?.path) {
            case ("POST", "/api/v1/exams/generate"):
                return try MockURLProtocol.response(for: request, json: Self.generatedExamJSON)
            case ("POST", "/api/v1/exams/exam-123/submit"):
                return try MockURLProtocol.response(for: request, json: Self.resultJSON)
            case ("GET", "/api/v1/exams/exam-123/result"):
                return try MockURLProtocol.response(for: request, json: Self.resultJSON)
            default:
                throw URLError(.badURL)
            }
        }
        let viewModel = PracticeViewModel(apiService: service)
        viewModel.topic = "Swift"
        await viewModel.generateExam()
        viewModel.selectOption("a")
        viewModel.nextQuestion()
        viewModel.selectOption("b")

        await viewModel.submitExam()

        XCTAssertEqual(viewModel.screen, .results)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.examResult?.totalQuestions, 2)
        XCTAssertEqual(viewModel.examResult?.correctAnswers, 1)
        XCTAssertEqual(viewModel.examResult?.incorrectAnswers, 1)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertEqual(
            MockURLProtocol.lastRequest?.url?.path,
            "/api/v1/exams/exam-123/result"
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
                json: #"{"detail":"El idioma no es válido."}"#
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

    private static let generatedExamJSON = """
    {
      "exam_id": "exam-123",
      "topic": "Swift",
      "difficulty": "intermediate",
      "language": "es",
      "questions": [
        {
          "id": "q1",
          "statement": "First question",
          "options": [
            {"id": "a", "text": "First answer"},
            {"id": "b", "text": "Second answer"}
          ]
        },
        {
          "id": "q2",
          "statement": "Second question",
          "options": [
            {"id": "a", "text": "First answer"},
            {"id": "b", "text": "Second answer"}
          ]
        }
      ]
    }
    """

    private static let resultJSON = """
    {
      "exam_id": "exam-123",
      "score": 50.0,
      "total_questions": 2,
      "correct_answers": 1,
      "incorrect_answers": 1,
      "results": [
        {
          "question_id": "q1",
          "selected_option_id": "a",
          "correct_option_id": "a",
          "is_correct": true,
          "explanation": "First answer is correct."
        },
        {
          "question_id": "q2",
          "selected_option_id": "b",
          "correct_option_id": "a",
          "is_correct": false,
          "explanation": "First answer is correct."
        }
      ]
    }
    """
}
