import Foundation

@MainActor
protocol FeedViewModelProtocol: ObservableObject {
    var items: [FeedItemViewModel] { get }
    
    func load() async
    func loadNext() async
}
