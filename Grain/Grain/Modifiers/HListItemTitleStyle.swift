import SwiftUI

// MARK: - HListItemTitleStyle

/// Используется для отображения заголовков элементов в FiltersHListView, TexturesHListView и RawPreviewView
private struct HListItemTitleStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.h6)
            .minimumScaleFactor(0.1)
            .foregroundStyle(Color.text)
            .frame(height: 20)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, .xs)
            .background(Color.background.opacity(0.5))
    }
}

extension View {
    /// Применяет модификатор HListItemTitleStyle
    func hListItemTitleStyle() -> some View {
        modifier(HListItemTitleStyle())
    }
}
