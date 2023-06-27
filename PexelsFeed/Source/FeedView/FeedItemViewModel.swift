import Foundation

struct FeedItemViewModel: Identifiable {
    let id: UInt64
    let size: CGSize
    let authorName: String
    let feedImageURL: URL
    let fullImageURL: URL
}
