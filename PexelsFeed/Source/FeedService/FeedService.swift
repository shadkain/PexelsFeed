import Foundation

final class FeedService: FeedServiceProtocol {
    private let apiKey: String
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    // MARK: - FeedServiceProtocol
    
    func fetch() async throws -> FeedServiceResponse {
        let request = try makeRequest()
        return try await fetch(using: request)
    }
    
    func fetchNext(using urlString: String) async throws -> FeedServiceResponse {
        let request = try makeRequest(with: urlString)
        return try await fetch(using: request)
    }
    
    // MARK: - Private
    
    private func makeRequest(with urlString: String = .curatedUrlString) throws -> URLRequest {
        guard var url = URL(string: urlString) else {
            throw FeedServiceError.urlCreationFailed
        }
        
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData)
        request.httpMethod = .getMethod
        request.addValue(apiKey, forHTTPHeaderField: .authorizationHeader)
        return request
    }
    
    private func fetch(using request: URLRequest) async throws -> FeedServiceResponse {
        let urlSession = URLSession(configuration: .ephemeral)
        let (data, _) = try await urlSession.data(for: request)
        let response = try JSONDecoder().decode(FeedServiceResponse.self, from: data)
        return response
    }
}

// MARK: - Constants

private extension String {
    static let curatedUrlString = "https://api.pexels.com/v1/curated"
    static let getMethod = "GET"
    static let authorizationHeader = "Authorization"
}
