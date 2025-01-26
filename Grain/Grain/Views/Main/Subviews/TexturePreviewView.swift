import SwiftUI

struct TexturePreviewView: View {
    // MARK: Properties

    var didTap: (() -> Void)?

    private let isSelected: Bool
    private let texture: Texture

    // MARK: Lifecycle

    init(texture: Texture, isSelected: Bool = false, didTap: (() -> Void)?) {
        self.texture = texture
        self.isSelected = isSelected
        self.didTap = didTap
    }

    // MARK: Content Properties

    var body: some View {
        Button {
            didTap?()
        } label: {
            Image(texture.filename)
                .resizable()
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
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(isSelected ? Color.textWhite : .clear, lineWidth: 2)
                )
        }
    }
}

#Preview {
    if let texture = DataStorage.shared.texturesCategories.first?.textures.first {
        TexturePreviewView(texture: texture) {}
    }
}
