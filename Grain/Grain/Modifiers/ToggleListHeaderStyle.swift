import SwiftUI

fileprivate struct ToggleListHeaderStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.h4)
            .foregroundStyle(Color.text.opacity(0.8))
            .padding(.bottom, 5)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

extension View {
    func toggleListHeaderStyle() -> some View {
        self.modifier(ToggleListHeaderStyle())
    }
}
