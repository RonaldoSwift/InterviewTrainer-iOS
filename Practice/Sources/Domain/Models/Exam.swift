public struct Exam: Equatable {
    public let id: String
    public let topic: String
    public let difficulty: String
    public let language: ExamLanguage
    public let questions: [Question]

    public init(
        id: String,
        topic: String,
        difficulty: String,
        language: ExamLanguage,
        questions: [Question]
    ) {
        self.id = id
        self.topic = topic
        self.difficulty = difficulty
        self.language = language
        self.questions = questions
    }
}
