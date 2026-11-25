public struct ExamResult: Equatable {
    public let examID: String
    public let score: Double
    public let results: [QuestionResult]

    public var totalQuestions: Int {
        results.count
    }

    public var correctAnswers: Int {
        results.filter { $0.isCorrect }.count
    }

    public var incorrectAnswers: Int {
        totalQuestions - correctAnswers
    }

    public init(examID: String, score: Double, results: [QuestionResult]) {
        self.examID = examID
        self.score = score
        self.results = results
    }
}
