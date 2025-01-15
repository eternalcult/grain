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
                    Text(texture.title)
                        .font(.h6)
                        .minimumScaleFactor(0.1)
                        .foregroundStyle(Color.textBlack)
                        .frame(height: 20)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 4)
                        .background(Color.backgroundWhite.opacity(0.5))

                }
                .clipShape(.rect(cornerRadius: 4))
        }
    }
}


#Preview {
    if let texture = texturesCategories.first?.textures.first {
        TexturePreviewView(texture: texture) {
            print("Did tap on texture preview")
        }
    }
}
