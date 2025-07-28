import SwiftUI

struct PropertyDoubleSliderView: View {
    // MARK: SwiftUI Properties

    let title: String
    @Binding var mainProperty: ImagePropertyProtocol
    @Binding var additionalProperty: ImagePropertyProtocol

    // MARK: Content Properties

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.h5)
                .foregroundStyle(Color.text.opacity(0.8))
            VStack(alignment: .leading, spacing: .none) {
                Text(mainProperty.title)
                    .font(.h5)
                    .foregroundStyle(Color.text.opacity(0.8))
                    + Text(": \(mainProperty.formattedValue())")
                    .font(.h6)
                    .foregroundStyle(Color.text.opacity(0.8))
                Slider(value: $mainProperty.current, in: mainProperty.range)
                    .tint(Color.text.opacity(0.1))
            }
            .onTapGesture(count: 2) {
                mainProperty.setToDefault()
            }
            VStack(alignment: .leading, spacing: .none) {
                Text(additionalProperty.title)
                    .font(.h5)
                    .foregroundStyle(Color.text.opacity(0.8))
                    + Text(": \(additionalProperty.formattedValue())")
                    .font(.h6)
                    .foregroundStyle(Color.text.opacity(0.8))
                Slider(value: $additionalProperty.current, in: additionalProperty.range)
                    .tint(Color.text.opacity(0.1))
            }
            .onTapGesture(count: 2) {
                additionalProperty.setToDefault()
            }
        }
    }
}
