import SwiftUI

struct PhotoEditorView: View {
    // MARK: SwiftUI Properties

    @Environment(MainRouter.self) private var router
    @Environment(MainViewModel.self) private var viewModel

    // MARK: Content Properties

    var body: some View {
        VStack(spacing: 8) {
            VStack {
                ZStack(alignment: .trailing) {
                    if let sourceImage = viewModel.sourceImage {
                        sourceImage
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.backgroundSecondary.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    if let finalImage = viewModel.finalImage {
                        finalImage
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .opacity(viewModel.showsFilteredImage ? 1 : 0)
                            .onLongPressGesture {} onPressingChanged: { isPressing in
                                HapticFeedback.soft()
                                viewModel.showsFilteredImage = !isPressing
                            }
                    }
                }
                .overlay(alignment: .bottomLeading) {
                    if viewModel.showsHistogram, let histogram = viewModel.histogram {
                        Image(uiImage: histogram)
                            .resizable()
                            .opacity(0.8)
                            .frame(width: 100, height: 50)
                            .padding()
                    }
                }
                HStack(spacing: 0) {
                    Button {
                        viewModel.showsHistogram.toggle()
                    } label: {
                        Image(systemName: "waveform.path.ecg.rectangle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .padding(4)
                            .tint(viewModel.showsHistogram ? Color.textBlack : Color.text)
                            .background(viewModel.showsHistogram ? Color.backgroundWhiteSecondary.opacity(0.8) : .clear)
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                    }
                    .padding(4)
                    Button {
                        viewModel.closeImage()
                    } label: {
                        Image(systemName: "xmark.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .padding(4)
                            .tint(Color.text)
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                    }
                }
            }

            ScrollView(.vertical) {
                VStack(spacing: 8) {
                    FiltersView()
                    ImagePropertiesView()
                    EffectsView()
                    TexturesView()
                }
            }
            .scrollIndicators(.hidden)
        }
    }
}
