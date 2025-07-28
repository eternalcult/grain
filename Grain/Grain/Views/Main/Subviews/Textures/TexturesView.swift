import SwiftUI

struct TexturesView: View {
    // MARK: SwiftUI Properties

    @Environment(MainRouter.self) private var router
    @Environment(MainViewModel.self) private var viewModel

    // MARK: Content Properties

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Button {
                viewModel.showsTextures.toggle()
            } label: {
                HStack {
                    HStack(alignment: .center) {
                        HStack {
                            Text("Textures")
                                .toggleListHeaderStyle()
                            Button {
                                viewModel.applyRandomTexture()
                            } label: {
                                Image(systemName: "dice")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .tint(.text.opacity(0.8))
                            }
                        }
                        .padding(.trailing, 8)
                        Button {
                            router.push(MainRoute.gallery(.textures))
                        } label: {
                            Text("Show all")
                                .showAllButtonStyle()
                        }
                    }
                    Spacer()
                    Image(systemName: "triangle.fill")
                        .resizable()
                        .frame(width: 10, height: 10)
                        .rotationEffect(viewModel.showsTextures ? Angle(degrees: 180) : Angle(degrees: 0))
                        .tint(.text.opacity(0.8))
                }
            }
            if viewModel.showsTextures {
                VStack(spacing: 8) {
                    TexturesHListView()
                        .environment(viewModel)

                    if viewModel.hasTexture {
                        VStack(spacing: 0) {
                            HStack {
                                Text("Blend mode:")
                                    .font(.h5)
                                    .foregroundStyle(Color.text.opacity(0.8))
                                Text(viewModel.textureBlendMode.title)
                                    .font(.h5)
                                    .foregroundStyle(Color.text.opacity(0.8))
                                Spacer()
                                Button {
                                    router.push(MainRoute.blendMode)
                                } label: {
                                    Image(systemName: "questionmark.circle.fill")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .tint(.text.opacity(0.8))
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            Slider(value: Binding(
                                get: { Double(viewModel.textureBlendMode.rawValue) },
                                set: { viewModel.textureBlendMode = BlendMode(rawValue: Int($0)) ?? .normal }
                            ), in: BlendMode.range, step: 1)
                                .tint(Color.text.opacity(0.1))
                        }
                        VStack(spacing: 0) {
                            HStack {
                                Text("Intensity:")
                                    .font(.h5)
                                    .foregroundStyle(Color.text.opacity(0.8))
                                let formattedTextureIntensity = viewModel.textureAlpha.formatValueToAnotherRange(
                                    currentMin: 0,
                                    currentMax: 1,
                                    newMin: 0,
                                    newMax: 100
                                )
                                Text(String(format: "%.0f%%", formattedTextureIntensity))
                                    .font(.h5)
                                    .foregroundStyle(Color.text.opacity(0.8))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            Slider(value: Binding(
                                get: { viewModel.textureAlpha },
                                set: { viewModel.textureAlpha = $0 }
                            ), in: 0 ... 1)
                                .tint(Color.text.opacity(0.1))
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.backgroundSecondary.opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
