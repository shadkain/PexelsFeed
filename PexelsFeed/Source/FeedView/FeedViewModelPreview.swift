import Foundation

enum SamplePhoto {
    static let url1 = Bundle.main.url(
        forResource: "sample_photo",
        withExtension: "jpeg"
    )
}

final class FeedViewModelPreview: FeedViewModelProtocol {
    @Published
    var items: [FeedItemViewModel] = []
    
    // MARK: - FeedViewModelProtocol
    
    func load() async {
        try! await Task.sleep(for: .seconds(1))
        items = (0...10)
            .map { item(with: UInt64($0)) }
    }
    
    func loadNext() async {
        try! await Task.sleep(for: .seconds(0.3))
        items.append(item(with: UInt64(items.count)))
    }
    
    // MARK: - Private
    
    private func item(with id: UInt64) -> FeedItemViewModel {
        FeedItemViewModel(
            id: id,
            size: CGSize(width: 4000, height: 6000),
            authorName: "Ph: Sample photo \(id)",
            feedImageURL: SamplePhoto.url1!,
            fullImageURL: SamplePhoto.url1!
        )
    }
}
