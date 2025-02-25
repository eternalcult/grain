import SwiftUI

/// Стиль кнопки ShowAll
fileprivate struct ShowAllButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.h5)
            .italic()
            .foregroundStyle(Color.text)
    }
}


extension View {
    /// Применяет ShowAllButtonStyle модификатор
    func showAllButtonStyle() -> some View {
        self.modifier(ShowAllButtonStyle())
    }
}
