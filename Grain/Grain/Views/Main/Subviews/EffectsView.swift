import SwiftUI

struct EffectsView: View {
    // MARK: SwiftUI Properties

    @Environment(MainViewModel.self) private var viewModel

    // MARK: Content Properties

    var body: some View {
        VStack(alignment: .leading, spacing: .s) {
            Button {
                viewModel.showsEffects.toggle()
            } label: {
                HStack {
                    HStack(alignment: .center) {
                        Text("Effects")
                            .font(.h4)
                            .foregroundStyle(Color.text.opacity(0.8))
                            .padding(.bottom, .xs)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        if viewModel.hasModifiedEffects {
                            Button {
                                viewModel.resetEffects()
                            } label: {
                                Image(systemName: "arrow.trianglehead.counterclockwise")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .tint(.text.opacity(0.8))
                            }
                        }
                        Spacer()
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
                VStack(spacing: .none) {
                    PropertyDoubleSliderView(
                        title: "Vignette",
                        mainProperty: Binding(
                            get: { viewModel.vignette.intensity },
                            set: { viewModel.vignette.intensity = $0 }
                        ),
                        additionalProperty: Binding(
                            get: { viewModel.vignette.radius },
                            set: { viewModel.vignette.radius = $0 }
                        )
                    )
                    PropertyDoubleSliderView(
                        title: "Bloom",
                        mainProperty: Binding(
                            get: { viewModel.bloom.intensity },
                            set: { viewModel.bloom.intensity = $0 }
                        ),
                        additionalProperty: Binding(
                            get: { viewModel.bloom.radius },
                            set: { viewModel.bloom.radius = $0 }
                        )
                    )
                }
            }
        }
        .padding(.horizontal, .m)
        .padding(.vertical, 12)
        .background(Color.backgroundSecondary.opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
