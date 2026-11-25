struct QuestionResponseDTO: Codable {
    let id: String
    let statement: String
    let options: [AnswerOptionResponseDTO]
}
