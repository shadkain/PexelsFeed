import Foundation

struct FeedFactory {
    private let apiKey: String
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    func makeFeedViewModel() -> some FeedViewModelProtocol {
        let service = FeedService(apiKey: apiKey)
        return FeedViewModel(service: service)
    }
}
