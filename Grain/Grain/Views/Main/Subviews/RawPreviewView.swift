import SwiftUI

struct RawPreviewView: View {
    // MARK: Properties

    var didTap: (() -> Void)?

    private let isSelected: Bool

    // MARK: Lifecycle

    init(isSelected: Bool = false, didTap: (() -> Void)?) {
        self.isSelected = isSelected
        self.didTap = didTap
    }

    // MARK: Content Properties

    var body: some View {
        Button {
            didTap?()
        } label: {
            VStack {
                Spacer()
                Text("None")
                    .font(.h6)
                    .minimumScaleFactor(0.1)
                    .foregroundStyle(Color.text)
                    .frame(height: 20)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 4)
                    .background(Color.background.opacity(0.5))
                Spacer()
            }
            .clipShape(.rect(cornerRadius: 4))
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(isSelected ? Color.text : .clear, lineWidth: 2)
            )
        }
    }
}
