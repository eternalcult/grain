import SwiftUI

struct EffectsView: View {
    @State private var viewModel: MainViewModel

    init(with parentViewModel: MainViewModel) {
        self.viewModel = parentViewModel
    }
    
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
                        mainProperty: $viewModel.vignetteIntensity,
                        additionalProperty: $viewModel.vignetteRadius
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
