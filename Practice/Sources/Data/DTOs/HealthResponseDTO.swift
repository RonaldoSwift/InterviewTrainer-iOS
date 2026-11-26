struct HealthResponseDTO: Codable {
    let status: HealthStatusDTO
}

enum HealthStatusDTO: String, Codable {
    case ok
}
