import SwiftUI

struct FullscreenImagePreviewView: View {
    @Binding var isShow: Bool
    let image: CGImage

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            Image(uiImage: UIImage(cgImage: image))
                .resizable()
                .scaledToFit()
        }
        .onTapGesture {
            isShow = false
        }
    }
}
