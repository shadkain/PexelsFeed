import SwiftUI

protocol ImageCache {
    func getImage(for key: String) -> Image?
    func setImage(_ image: Image?, for key: String)
}
