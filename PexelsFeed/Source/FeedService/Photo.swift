struct Photo: Codable {
    let id: UInt64
    let width: Int
    let height: Int
    let photographerName: String
    let source: Source
    
    enum CodingKeys: String, CodingKey {
        case id, width, height
        case photographerName = "photographer"
        case source = "src"
    }
}

// MARK: - Source

extension Photo {
    struct Source: Codable {
        let originalURL: String
        let largeURL: String
        
        enum CodingKeys: String, CodingKey {
            case originalURL = "original"
            case largeURL = "large"
        }
    }
}
