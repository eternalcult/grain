import SwiftUI

struct EffectsView: View {
    // MARK: SwiftUI Properties

    @State private var viewModel: MainViewModel

    // MARK: Lifecycle

    init(with parentViewModel: MainViewModel) { // TODO: Вот тут случайно не retain cycle получается?
        viewModel = parentViewModel
    }

    // MARK: Content Properties

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Button {
                viewModel.showsEffects.toggle()
            } label: {
                HStack {
                    HStack(alignment: .center) {
                        Text("Effects")
                            .font(.h4)
                            .foregroundStyle(Color.text.opacity(0.8))
                            .padding(.bottom, 5)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    Spacer()
                    Image(systemName: "triangle.fill")
                        .resizable()
                        .frame(width: 10, height: 10)
                        .rotationEffect(viewModel.showsEffects ? Angle(degrees: 180) : Angle(degrees: 0))
                        .tint(.text.opacity(0.8))
                }
            }
            if viewModel.showsEffects {
                VStack(spacing: 0) {
                    PropertyDoubleSliderView(
                        title: "Vignette",
                        mainProperty: $viewModel.vignette.intensity,
                        additionalProperty: $viewModel.vignette.radius
                    )
                    PropertyDoubleSliderView(
                        title: "Bloom",
                        mainProperty: $viewModel.bloom.intensity,
                        additionalProperty: $viewModel.bloom.radius
                    )
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.backgroundSecondary.opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
