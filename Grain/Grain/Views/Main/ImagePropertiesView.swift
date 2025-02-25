import SwiftUI

struct ImagePropertiesView: View {
    // MARK: SwiftUI Properties

    @State private var viewModel: MainViewModel

    // MARK: Lifecycle

    init(with parentViewModel: MainViewModel) {
        viewModel = parentViewModel
    }

    // MARK: Content Properties

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Button {
                viewModel.showsSettings.toggle()
            } label: {
                HStack(alignment: .center) {
                    HStack {
                        Text("Settings")
                            .toggleListHeaderStyle()
                        if viewModel.hasModifiedProperties {
                            Button {
                                viewModel.resetSettings()
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
                        .rotationEffect(viewModel.showsSettings ? Angle(degrees: 180) : Angle(degrees: 0))
                        .tint(.text.opacity(0.8))
                }
            }
            if viewModel.showsSettings {
                VStack(spacing: 0) {
                    PropertySliderView(property: $viewModel.brightness)
                    PropertySliderView(property: $viewModel.contrast)
                    PropertySliderView(property: $viewModel.saturation)
                    PropertySliderView(property: $viewModel.exposure)
                    PropertySliderView(property: $viewModel.vibrance)
                    PropertySliderView(property: $viewModel.highlights)
                    PropertySliderView(property: $viewModel.shadows)
                    PropertySliderView(property: $viewModel.temperature)
                    PropertySliderView(property: $viewModel.tint)
                    PropertySliderView(property: $viewModel.gamma)
                    PropertySliderView(property: $viewModel.noiseReduction)
                    PropertySliderView(property: $viewModel.sharpness)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.backgroundSecondary.opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
