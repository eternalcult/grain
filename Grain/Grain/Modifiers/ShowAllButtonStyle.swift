import SwiftUI

fileprivate struct ShowAllButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.h5)
            .italic()
            .foregroundStyle(Color.text)
    }
}


extension View {
    func showAllButtonStyle() -> some View {
        self.modifier(ShowAllButtonStyle())
    }
}
