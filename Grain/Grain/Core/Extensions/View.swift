import SwiftUI

public extension View {
    func failureAlert(_ isVisible: Binding<Bool>, title: String? = nil, message: String? = nil, duration: Double) -> some View {
        let settings = AlertSettings(
            showingMode: .temporary(duration: duration),
            icon: .init(sfSymbolName: "xmark.circle.fill", size: .init(width: 32, height: 32), color: .red),
            title: title,
            message: message
        )
        return modifier(AlertModifier(isVisible: isVisible, settings))
    }
}
