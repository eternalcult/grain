import SwiftUI

// MARK: - SliderView

struct SliderView: View {
    // MARK: SwiftUI Properties

    @Binding var property: ImageProperty

    // MARK: Content Properties

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(property.title) + Text(": \(property.formattedValue())")
                .font(.h5)
                .foregroundStyle(Color.textWhite.opacity(0.8))
            Slider(value: $property.current, in: property.range)
                .tint(Color.textWhite.opacity(0.1))
        }
        .onTapGesture(count: 2) {
            property.setToDefault()
        }
    }
}

#Preview {
    MainView()
}

// MARK: - DoubleSlider

struct DoubleSlider: View {
    // MARK: SwiftUI Properties

    let title: String
    @Binding var mainProperty: ImageProperty
    @Binding var additionalProperty: ImageProperty

    // MARK: Content Properties

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.h5)
                .foregroundStyle(Color.textWhite.opacity(0.8))
            VStack(alignment: .leading, spacing: 0) {
                Text(mainProperty.title) + Text(": \(mainProperty.formattedValue())")
                    .font(.h6)
                    .foregroundStyle(Color.textWhite.opacity(0.8))
                Slider(value: $mainProperty.current, in: mainProperty.range)
                    .tint(Color.textWhite.opacity(0.1))
            }
            .onTapGesture(count: 2) {
                mainProperty.setToDefault()
            }
            VStack(alignment: .leading, spacing: 0) {
                Text(additionalProperty.title) + Text(": \(additionalProperty.formattedValue())")
                    .font(.h6)
                    .foregroundStyle(Color.textWhite.opacity(0.8))
                Slider(value: $additionalProperty.current, in: additionalProperty.range)
                    .tint(Color.textWhite.opacity(0.1))
            }
            .onTapGesture(count: 2) {
                additionalProperty.setToDefault()
            }
        }
    }
}
