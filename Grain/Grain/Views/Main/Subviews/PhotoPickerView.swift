import PhotosUI
import SwiftUI

struct MainPhotoPickerView: View {
    // MARK: SwiftUI Properties

    @State private var viewModel: MainViewModel

    // MARK: Lifecycle

    init(with parentViewModel: MainViewModel) {
        viewModel = parentViewModel
    }

    // MARK: Content Properties

    var body: some View {
        ZStack {
            if let url = Bundle.main.url(forResource: "background", withExtension: "mp4") {
                VideoBackgroundView(url: url)
                    .opacity(0.7)
            }
            PhotosPicker(selection: $viewModel.selectedItem, matching: .images) {
                Rectangle()
                    .fill(.clear)
                    .overlay(alignment: .center) {
                        VStack {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .tint(.text)
                                .frame(width: 20, height: 20)
                            Text("Tap to choose an image\nfrom the gallery.")
                                .font(.custom(size: 12))
                                .foregroundStyle(Color.text)
                        }.opacity(0.5)
                    }
            }
            .onChange(of: viewModel.selectedItem) { _, _ in
                viewModel.prepareForEditing()
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}
