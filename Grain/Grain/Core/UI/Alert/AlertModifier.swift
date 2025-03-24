import SwiftUI

struct AlertModifier: ViewModifier {
    // MARK: SwiftUI Properties

    @Binding var isVisible: Bool

    // MARK: Properties

    private let settings: AlertSettings

    // MARK: Lifecycle

    init(
        isVisible: Binding<Bool>,
        _ settings: AlertSettings
    ) {
        _isVisible = isVisible
        self.settings = settings
    }

    // MARK: Content Methods

    func body(content: Content) -> some View {
        ZStack {
            content
                .overlay(alignment: .center) {
                    if isVisible {
                        AlertView(settings: settings)
                    }
                }
        }
        .animation(.easeInOut(duration: 0.3), value: isVisible)
        .onChange(of: isVisible) { _, _ in
            if isVisible {
                switch settings.mode {
                case let .temporary(duration):
                    DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                        withAnimation {
                            isVisible = false
                        }
                    }

                case .fixed:
                    break
                }
            }
        }
    }
}
