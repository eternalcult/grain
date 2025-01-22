import SwiftUI

struct RawPreviewView: View {
    private let isSelected: Bool
    var didTap: (() -> Void)?

    init(isSelected: Bool = false, didTap: (() -> Void)?) {
        self.isSelected = isSelected
        self.didTap = didTap
    }

    var body: some View {
        Button {
            didTap?()
        } label: {
            VStack {
                Spacer()
                Text("None")
                    .font(.h6)
                    .minimumScaleFactor(0.1)
                    .foregroundStyle(Color.textBlack)
                    .frame(height: 20)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 4)
                    .background(Color.backgroundWhite.opacity(0.5))
                Spacer()
            }
            .clipShape(.rect(cornerRadius: 4))
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(isSelected ? Color.textWhite : .clear, lineWidth: 2)
            )
        }
    }
}
