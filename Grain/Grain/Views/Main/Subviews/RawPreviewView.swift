import SwiftUI

/// Используется отображения в FiltersScrollView и TexturesHListView пустого состояния, когда не выбран ни один из фильтров/текстур
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
                    .background(Color.backgroundSecondary.opacity(0.5))
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
