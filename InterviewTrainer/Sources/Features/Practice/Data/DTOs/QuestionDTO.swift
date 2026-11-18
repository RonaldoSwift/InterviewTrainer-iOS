
/*
- questionId: identificador de la pregunta.
- statement: enunciado.
- codeSnippet: fragmento de código opcional.
- options: alternativas de respuesta.
Usamos Decodable porque estos datos llegan desde el backend hacia nuestra aplicación.
*/

import Foundation

public struct QuestionDTO: Decodable {
    public let questionId: String
    public let statement: String
    public let codeSnippet: String?
    public let options: [AnswerOptionDTO]

    enum CodingKeys: String, CodingKey {
        case questionId = "question_id"
        case statement
        case codeSnippet = "code_snippet"
        case options
    }
}