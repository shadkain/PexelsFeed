import SwiftUI

@main
struct PexelsFeedApp: App {
    private let feedImageCache = {
        let cache = InMemoryImageCache()
        cache.countLimit = .feedCacheCountLimit
        return cache
    }()
    
    private let fullScreenImageCache = {
        let cache = InMemoryImageCache()
        cache.countLimit = .fullscreenCacheCountLimit
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

// MARK: - Constants

private extension Int {
    static let feedCacheCountLimit = 1_000
    static let fullscreenCacheCountLimit = 50
}
