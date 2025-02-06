import SwiftUI

// MARK: - SliderView

struct PropertySliderView: View {
    // MARK: SwiftUI Properties

    @Binding var property: ImageProperty

    // MARK: Content Properties

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(property.title)
                .font(.h5)
                .foregroundStyle(Color.text.opacity(0.8))
            + Text(": \(property.formattedValue())")
                .font(.h5)
                .foregroundStyle(Color.text.opacity(0.8))
            Slider(value: $property.current, in: property.range)
                .tint(Color.text.opacity(0.1))
        }
        .onTapGesture(count: 2) {
            property.setToDefault()
        }
    }
}
