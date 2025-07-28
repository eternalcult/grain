import SwiftUI

// MARK: - PropertySliderView

struct PropertySliderView: View {
    // MARK: SwiftUI Properties

    @Binding var property: ImagePropertyProtocol

    // MARK: Content Properties

    var body: some View {
        VStack(alignment: .leading, spacing: .none) {
            Text(property.title)
                .font(.h5)
                .foregroundStyle(Color.text.opacity(0.8))
                + Text(": \(property.formattedValue())")
                .font(.h5)
                .foregroundStyle(Color.text.opacity(0.8))
            Slider(value: $property.current, in: property.range, step: property.step)
                .tint(Color.text.opacity(0.1))
        }
        .onTapGesture(count: 2) {
            property.setToDefault()
        }
    }
}
