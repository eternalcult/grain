import SwiftUI

struct AlertView: View {
    // MARK: Properties

    let settings: AlertSettings

    // MARK: Content Properties

    var body: some View {
        VStack {
            Image(systemName: settings.icon.sfSymbolName)
                .resizable()
                .frame(width: settings.icon.size.width, height: settings.icon.size.height)
                .foregroundStyle(settings.icon.color)
            if let title = settings.title {
                Text(title)
                    .font(.h4)
                    .foregroundStyle(settings.textColor)
            }
            if let message = settings.message {
                Text(message)
                    .font(.text)
                    .foregroundStyle(settings.textColor)
            }
        }
        .padding()
        .background(settings.backgroundColor)
        .clipShape(.rect(cornerRadius: settings.cornerRadius))
        .frame(maxWidth: settings.maxWidth)
        .onAppear {
            HapticFeedback.error()
        }
    }
}
