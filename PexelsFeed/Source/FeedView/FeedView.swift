import SwiftUI

struct FeedView<ViewModel: FeedViewModelProtocol>: View {
    
    // MARK: - Properties
    
    @ObservedObject
    var viewModel: ViewModel
    let feedImageCache: ImageCache
    let fullScreenImageCache: ImageCache
    
    @State
    private var isLoadingNext: Bool = false
    @State
    private var presentedItem: FeedItemViewModel?
    
    // MARK: - View
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.items) { item in
                    FeedItemView(
                        viewModel: item,
                        imageCache: feedImageCache
                    ) {
                        presentedItem = item
                    }
                    .task {
                        if item.id == viewModel.items.last?.id {
                            isLoadingNext = true
                            await viewModel.loadNext()
                            isLoadingNext = false
                        }
                    }
                }
                
                if isLoadingNext {
                    ProgressView()
                }
            }
        }
        .background(Color.gray)
        .refreshable {
            await viewModel.load()
        }
        .task {
            await viewModel.load()
        }
        .fullScreenCover(item: $presentedItem) { item in
            FullscreenImageView(
                url: item.fullImageURL,
                imageCache: fullScreenImageCache
            )
        }
    }
}

// MARK: - Previews

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView(
            viewModel: FeedViewModelPreview(),
            feedImageCache: InMemoryImageCache(),
            fullScreenImageCache: InMemoryImageCache()
        )
    }
}
