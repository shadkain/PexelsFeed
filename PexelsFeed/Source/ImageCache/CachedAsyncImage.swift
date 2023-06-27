import SwiftUI

struct CachedAsyncImage<Content: View>: View {
    
    // MARK: - Properties
    
    let url: URL
    let imageCache: ImageCache
    let scale: CGFloat
    let transaction: Transaction
    let content: (AsyncImagePhase) -> Content
    
    // MARK: - Initialization
    
    init(
        url: URL,
        imageCache: ImageCache,
        scale: CGFloat = 1.0,
        transaction: Transaction = Transaction(),
        @ViewBuilder content: @escaping (AsyncImagePhase) -> Content
    ) {
        self.url = url
        self.imageCache = imageCache
        self.scale = scale
        self.transaction = transaction
        self.content = content
    }
    
    // MARK: - View
    
    var body: some View {
        if let image = imageCache.getImage(for: url.absoluteString) {
            content(.success(image))
        } else {
            AsyncImage(
                url: url,
                scale: scale,
                transaction: transaction
            ) { phase in
                cachedImage(phase: phase)
            }
        }
    }
    
    // MARK: - Private
    
    private func cachedImage(phase: AsyncImagePhase) -> some View {
        if case let .success(image) = phase {
            imageCache.setImage(image, for: url.absoluteString)
        }
        
        return content(phase)
    }
}
