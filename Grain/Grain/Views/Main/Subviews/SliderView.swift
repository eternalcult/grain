import SwiftUI
struct SliderView: View {
    @Binding var filter: Filter

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("\(filter.title): \(String(format: "%.0f%%", filter.current * 100))")
                .font(.h5)
                .foregroundStyle(Color.textWhite.opacity(0.8))
            Slider(value: $filter.current, in: filter.range)
                .tint(Color.textWhite.opacity(0.1))
        }
        .onTapGesture(count: 2) {
            filter.setToDefault()
        }
    }
}


#Preview {
    MainView()
}
