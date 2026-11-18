
// Define los temas sobre los que el usuario podra practicar.

public enum ExamTopic: String, CaseIterable, Codable {
    case swift
    case swiftUI = "swiftui"
    case uiKit = "uikit"
    case concurrency
    case memoryManagement = "memory_management"
    case combine
    case architecture
}