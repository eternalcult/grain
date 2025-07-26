import SwiftUI

struct ImagePropertiesView: View {
    // MARK: SwiftUI Properties

    @Environment(MainViewModel.self) private var viewModel

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
                    PropertySliderView(
                        property: Binding(
                            get: { viewModel.brightness },
                            set: { viewModel.brightness = $0 }
                        )
                    )
                    PropertySliderView(
                        property: Binding(
                            get: { viewModel.contrast },
                            set: { viewModel.contrast = $0 }
                        )
                    )
                    PropertySliderView(
                        property: Binding(
                            get: { viewModel.saturation },
                            set: { viewModel.saturation = $0 }
                        )
                    )
                    PropertySliderView(
                        property: Binding(
                            get: { viewModel.exposure },
                            set: { viewModel.exposure = $0 }
                        )
                    )
                    PropertySliderView(
                        property: Binding(
                            get: { viewModel.vibrance },
                            set: { viewModel.vibrance = $0 }
                        )
                    )
                    PropertySliderView(
                        property: Binding(
                            get: { viewModel.highlights },
                            set: { viewModel.highlights = $0 }
                        )
                    )
                    PropertySliderView(
                        property: Binding(
                            get: { viewModel.shadows },
                            set: { viewModel.shadows = $0 }
                        )
                    )
                    PropertySliderView(
                        property: Binding(
                            get: { viewModel.temperature },
                            set: { viewModel.temperature = $0 }
                        )
                    )
                    PropertySliderView(
                        property: Binding(
                            get: { viewModel.tint },
                            set: { viewModel.tint = $0 }
                        )
                    )
                    PropertySliderView(
                        property: Binding(
                            get: { viewModel.gamma },
                            set: { viewModel.gamma = $0 }
                        )
                    )
                    PropertySliderView(
                        property: Binding(
                            get: { viewModel.noiseReduction },
                            set: { viewModel.noiseReduction = $0 }
                        )
                    )
                    PropertySliderView(
                        property: Binding(
                            get: { viewModel.sharpness },
                            set: { viewModel.sharpness = $0 }
                        )
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
