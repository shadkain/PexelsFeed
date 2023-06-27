import SwiftUI

@main
struct PexelsFeedApp: App {
    private let feedImageCache = {
        let cache = InMemoryImageCache()
        cache.countLimit = 1000
        return cache
    }()
    
    private let fullScreenImageCache = {
        let cache = InMemoryImageCache()
        cache.countLimit = 50
        return cache
    }()
    
    var body: some Scene {
        let factory = FeedFactory(apiKey: ApiKeys.pexelsApiKey)
        
        WindowGroup {
            FeedView(
                viewModel: factory.makeFeedViewModel(),
                feedImageCache: feedImageCache,
                fullScreenImageCache: fullScreenImageCache
            )
        }
    }
}
