struct FeedServiceResponse: Codable {
    let page: Int
    let perPage: Int
    let photos: [Photo]
    let nextPage: String
    
    enum CodingKeys: String, CodingKey {
        case page
        case perPage = "per_page"
        case photos
        case nextPage = "next_page"
    }
}
