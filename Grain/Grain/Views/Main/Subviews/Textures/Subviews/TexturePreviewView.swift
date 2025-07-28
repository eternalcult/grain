import SwiftUI

struct TexturePreviewView: View {
    // MARK: Properties

    var didTap: OptionalCompletion

    private let isSelected: Bool
    private let texture: Texture

    // MARK: Lifecycle

    init(
        texture: Texture,
        isSelected: Bool = false,
        didTap: OptionalCompletion
    ) {
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
                        .hListItemTitleStyle()
                }
                .clipShape(.rect(cornerRadius: 4))
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(isSelected ? Color.text : .clear, lineWidth: 2)
                )
        }
    }
}
