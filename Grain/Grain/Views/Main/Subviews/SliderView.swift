import SwiftUI
struct SliderView: View {
    @Binding var filter: Filter

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("\(filter.title): \(String(format: "%.2f", filter.current))")
                .font(.headline)
            Slider(value: $filter.current, in: filter.range)
                .tint(.white)
        }.opacity(0.8)
    }
}
