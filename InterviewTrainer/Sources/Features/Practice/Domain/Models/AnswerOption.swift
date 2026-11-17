
/*
id: identificador local para SwiftUI.
optionId: identificador de la alternativa que reconoce el backend.
text: texto que verá el usuario.
*/

import Foundation

public struct AnswerOption: Identifiable {
    public let id: UUID
    public let optionId: String
    public let text: String

    public init(
        id: UUID = UUID(),
        optionId: String,
        text: String
    ) {
        self.id = id
        self.optionId = optionId
        self.text = text
    }
}