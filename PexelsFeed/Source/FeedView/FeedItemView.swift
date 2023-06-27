import SwiftUI

struct FeedItemView: View {
    
    // MARK: - Properties
    
    let viewModel: FeedItemViewModel
    let imageCache: ImageCache
    var onImageTap: (() -> Void)? = nil
    
    // MARK: - View
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(viewModel.authorName)
                .padding(.top, 8)
                .padding(.leading, 8)
            CachedAsyncImage(
                url: viewModel.feedImageURL,
                imageCache: imageCache,
                transaction: Transaction(animation: .easeIn)
            ) { phase in
                switch phase {
                case .empty:
                    ZStack {
                        Rectangle()
                            .fill(.gray)
                            .aspectRatio(viewModel.size, contentMode: .fit)
                        
                        ProgressView()
                    }
                case let .success(image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .onTapGesture {
                            onImageTap?()
                        }
                case .failure:
                    EmptyView()
                @unknown default:
                    EmptyView()
                }
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 5, y: 5)
    }
}

// MARK: - Previews

struct FeedItemView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.gray
                .ignoresSafeArea()
            
            FeedItemView(
                viewModel: .init(
                    id: 0,
                    size: .init(width: 4000, height: 6000),
                    authorName: "Ph: Author",
                    feedImageURL: SamplePhoto.url1!,
                    fullImageURL: SamplePhoto.url1!
                ),
                imageCache: InMemoryImageCache()
            )
        }
    }
}
