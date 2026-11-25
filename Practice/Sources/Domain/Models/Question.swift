public struct Question: Equatable {
    public let id: String
    public let statement: String
    public let options: [AnswerOption]

    public init(id: String, statement: String, options: [AnswerOption]) {
        self.id = id
        self.statement = statement
        self.options = options
    }
}
