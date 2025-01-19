import SwiftUI

struct FilterPreviewView: View {
    private let previewImage: CGImage
    private let title: String
    private let isSelected: Bool
    var didTap: (() -> Void)?

    init(previewImage: CGImage, title: String, isSelected: Bool = false, didTap: (() -> Void)?) {
        self.previewImage = previewImage
        self.title = title
        self.isSelected = isSelected
        self.didTap = didTap
    }

    var body: some View {
        Button {
            didTap?()
        } label: {
            Image(uiImage: UIImage(cgImage: previewImage))
                .resizable()
                .overlay(alignment: .bottom) {
                    Text(title)
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
