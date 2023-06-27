import Foundation

@MainActor
final class FeedViewModel: FeedViewModelProtocol {
    
    // MARK: - Properties
    
    @Published
    private(set) var items: [FeedItemViewModel] = []
    
    private var nextPage: String?
    private var ids: Set<UInt64> = []
    
    // MARK: - Dependencies
    
    private let service: FeedServiceProtocol
    
    // MARK: - Initialization
    
    nonisolated init(service: FeedServiceProtocol) {
        self.service = service
    }
    
    // MARK: - FeedViewModelProtocol
    
    func load() async {
        do {
            let res = try await service.fetch()
            nextPage = res.nextPage
            ids.removeAll()
            setItems(mapPhotos(res.photos))
        } catch {
            setItems([])
            nextPage = nil
        }
    }
    
    func loadNext() async {
        do {
            guard let nextPage else {
                return
            }
            
            let res = try await service.fetchNext(using: nextPage)
            self.nextPage = res.nextPage
            appendItems(mapPhotos(res.photos))
        } catch {
            
        }
    }
    
    // MARK: - Private
    
    private func mapPhotos(_ photos: [Photo]) -> [FeedItemViewModel] {
        photos
            .compactMap { photo in
                guard !ids.contains(photo.id),
                      let feedImageURL = URL(string: photo.source.largeURL)
                else {
                    return nil
                }
                
                let fullImageURL = URL(string: photo.source.originalURL)
                
                return FeedItemViewModel(
                    id: photo.id,
                    size: .init(
                        width: photo.width,
                        height: photo.height
                    ),
                    authorName: "Ph: \(photo.photographerName)",
                    feedImageURL: feedImageURL,
                    fullImageURL: fullImageURL ?? feedImageURL
                )
            }
    }
    
    private func setItems(_ items: [FeedItemViewModel]) {
        if items.isEmpty {
            ids.removeAll()
        }
        insertIds(from: items)
        self.items = items
    }
    
    private func appendItems(_ items: [FeedItemViewModel]) {
        insertIds(from: items)
        self.items.append(contentsOf: items)
    }
    
    private func insertIds(from items: [FeedItemViewModel]) {
        items
            .forEach { item in
                ids.insert(item.id)
            }
    }
}
