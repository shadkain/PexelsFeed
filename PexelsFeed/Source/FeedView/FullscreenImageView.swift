import SwiftUI

struct FullscreenImageView: View {
    let url: URL
    let imageCache: ImageCache
    
    @Environment(\.dismiss)
    private var dismiss
    @State
    private var offset: CGFloat = 0
    
    var body: some View {
        GeometryReader { reader in
            ZStack {
                Color.black
                    .ignoresSafeArea()
                    .onTapGesture {
                        dismiss()
                    }
                    
                CachedAsyncImage(
                    url: url,
                    imageCache: imageCache,
                    transaction: Transaction(animation: .easeIn)
                ) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case let .success(image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .offset(y: offset)
                    case .failure:
                        EmptyView()
                    @unknown default:
                        EmptyView()
                    }
                }
            }
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        offset = gesture.translation.height
                    }
                    .onEnded { gesture in
                        if abs(offset) > reader.size.height / 3 {
                            dismiss()
                        } else {
                            withAnimation(.easeInOut) {
                                offset = 0
                            }
                        }
                    }
            )
        }
    }
}

// MARK: - Previews

struct FullscreenImageView_Previews: PreviewProvider {
    static var previews: some View {
        FullscreenImageView(
            url: SamplePhoto.url1!,
            imageCache: InMemoryImageCache()
        )
    }
}
