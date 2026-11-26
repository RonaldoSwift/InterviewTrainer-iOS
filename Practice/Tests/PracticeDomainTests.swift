import XCTest
@testable import Practice

final class PracticeDomainTests: XCTestCase {
    func testAnswerOptionConstructionAndEquality() {
        let option = AnswerOption(id: "a", text: "First option")

        XCTAssertEqual(option, AnswerOption(id: "a", text: "First option"))
    }

    func testQuestionConstructionAndEquality() {
        let options = [
            AnswerOption(id: "a", text: "First option"),
            AnswerOption(id: "b", text: "Second option"),
        ]
        let question = Question(
            id: "q1",
            statement: "Choose an option",
            options: options
        )

        XCTAssertEqual(
            question,
            Question(id: "q1", statement: "Choose an option", options: options)
        )
    }

    func testExamConstructionAndEquality() {
        let questions = [
            Question(
                id: "q1",
                statement: "Choose an option",
                options: [AnswerOption(id: "a", text: "First option")]
            ),
        ]
        let exam = Exam(
            id: "exam-1",
            topic: "Swift",
            difficulty: "intermediate",
            language: .english,
            questions: questions
        )

        XCTAssertEqual(
            exam,
            Exam(
                id: "exam-1",
                topic: "Swift",
                difficulty: "intermediate",
                language: .english,
                questions: questions
            )
        )
    }

    func testExamAnswerConstructionAndEquality() {
        let answer = ExamAnswer(questionID: "q1", selectedOptionID: "b")

        XCTAssertEqual(answer, ExamAnswer(questionID: "q1", selectedOptionID: "b"))
    }

    func testQuestionResultConstructionAndEquality() {
        let result = QuestionResult(
            questionID: "q1",
            selectedOptionID: "a",
            correctOptionID: "a",
            explanation: "The first option is correct."
        )

        XCTAssertEqual(
            result,
            QuestionResult(
                questionID: "q1",
                selectedOptionID: "a",
                correctOptionID: "a",
                explanation: "The first option is correct."
            )
        )
        XCTAssertTrue(result.isCorrect)
    }

    func testQuestionResultIsIncorrectWhenOptionsDiffer() {
        let result = QuestionResult(
            questionID: "q1",
            selectedOptionID: "b",
            correctOptionID: "a",
            explanation: "The first option is correct."
        )

        XCTAssertFalse(result.isCorrect)
    }

    func testExamResultConstructionAndComputedCounts() {
        let results = [
            QuestionResult(
                questionID: "q1",
                selectedOptionID: "a",
                correctOptionID: "a",
                explanation: "Correct."
            ),
            QuestionResult(
                questionID: "q2",
                selectedOptionID: "b",
                correctOptionID: "a",
                explanation: "Incorrect."
            ),
        ]
        let examResult = ExamResult(examID: "exam-1", score: 50, results: results)

        XCTAssertEqual(
            examResult,
            ExamResult(examID: "exam-1", score: 50, results: results)
        )
        XCTAssertEqual(examResult.totalQuestions, 2)
        XCTAssertEqual(examResult.correctAnswers, 1)
        XCTAssertEqual(examResult.incorrectAnswers, 1)
    }

    func testExamResultComputedCountsAreZeroWhenThereAreNoResults() {
        let examResult = ExamResult(examID: "exam-1", score: 0, results: [])

        XCTAssertEqual(examResult.totalQuestions, 0)
        XCTAssertEqual(examResult.correctAnswers, 0)
        XCTAssertEqual(examResult.incorrectAnswers, 0)
    }

    func testExamLanguageCases() {
        let spanish = ExamLanguage.spanish
        let english = ExamLanguage.english

        XCTAssertEqual(spanish, .spanish)
        XCTAssertEqual(english, .english)
        XCTAssertNotEqual(spanish, english)
    }
}
