
//Porque nuestro contrato API establece que el backend recibirá estos códigos:español,inglés.

public enum ExamLanguage: String, CaseIterable, Codable {
    case spanish = "es"
    case english = "en"
}