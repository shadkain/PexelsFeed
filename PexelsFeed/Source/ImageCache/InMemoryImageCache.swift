import Foundation
import SwiftUI

final class InMemoryImageCache: ImageCache {
    
    // MARK: - Properties
    
    private let cache: NSCache<NSString, ImageWrapper> = NSCache()
    
    var countLimit: Int {
        get {
            cache.countLimit
        }
        set {
            cache.countLimit = newValue
        }
    }
    
    // MARK: - ImageCache
    
    func getImage(for key: String) -> Image? {
        cache.object(forKey: key as NSString)?.image
    }
    
    func setImage(_ image: Image?, for key: String) {
        if let image {
            cache.setObject(ImageWrapper(image: image), forKey: key as NSString)
        } else {
            cache.removeObject(forKey: key as NSString)
        }
    }
}

// MARK: - Private

private final class ImageWrapper {
    let image: Image
    
    init(image: Image) {
        self.image = image
    }
}
