import SwiftUI
struct TexturePreviewView: View {
    private let texture: Texture
    var didTap: (() -> Void)?

    init(texture: Texture, didTap: (() -> Void)?) {
        self.texture = texture
        self.didTap = didTap
    }

    var body: some View {
        Button {
            didTap?()
        } label: {
            Image(texture.filename)
                .resizable()
                .frame(width: 100, height: 100)
                .overlay(alignment: .bottom) {
                    Text(texture.name)
                        .font(.caption)
                        .minimumScaleFactor(0.1)
                        .foregroundStyle(.black)
                        .frame(height: 30)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 4)
                        .background(.white.opacity(0.8))

                }
                .clipShape(.rect(cornerRadius: 4))
        }
    }
}
