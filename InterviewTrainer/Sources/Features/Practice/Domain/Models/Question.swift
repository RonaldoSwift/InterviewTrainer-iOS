/*
id	Identificador local para SwiftUI.
questionId	Identificador de la pregunta enviado por el backend.
statement	Enunciado de la pregunta.
codeSnippet	Fragmento de código opcional.
options	Las alternativas de respuesta.
*/

import Foundation

public struct Question: Identifiable {
    public let id: UUID
    public let questionId: String
    public let statement: String
    public let codeSnippet: String?
    public let options: [AnswerOption]

    public init(
        id: UUID = UUID(),
        questionId: String,
        statement: String,
        codeSnippet: String? = nil,
        options: [AnswerOption]
    ) {
        self.id = id
        self.questionId = questionId
        self.statement = statement
        self.codeSnippet = codeSnippet
        self.options = options
    }
}