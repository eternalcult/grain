
import AppCore
import SwiftUI

struct MainView: View {
    // MARK: SwiftUI Properties

    @State private var router: MainRouter
    @State private var viewModel = MainViewModel()

    // MARK: Lifecycle

    init(viewModel: MainViewModel = MainViewModel()) {
        self.viewModel = viewModel
        router = MainRouter(viewModel: viewModel)
    }

    // MARK: Content Properties

    var body: some View {
        NavigationStack(path: $router.path) {
            VStack(spacing: 8) {
                if viewModel.sourceImage != nil, viewModel.finalImage != nil {
                    VStack(spacing: 0) {
                        MainHeaderView(with: viewModel)
                            .environment(router)
                        PhotoEditorView(with: viewModel)
                            .environment(router)
                    }
                    .padding(.horizontal, 8)
                } else {
                    MainPhotoPickerView(with: viewModel)
                }
            }
            .background(Color.background)
            .navigationBarBackButtonHidden(true)
            .onChange(of: viewModel.errorMessage) { _, newError in
                viewModel.showErrorAlert = newError != nil
            }
            .failureBlackAlert($viewModel.showErrorAlert, message: viewModel.errorMessage, duration: 3)
            .navigationDestination(for: MainRoute.self) { route in
                router.view(for: route).environment(router)
            }
            //        .onAppear { // Only for testing
            //            if let uiImage = UIImage(named: "preview"),
            //               let cgImage = uiImage.cgImage {
            //                viewModel.photoEditor.updateSourceImage(CIImage(cgImage: cgImage), orientation: .up)
            //            }
            //        }
        }
    }
}

#Preview {
    MainView()
}
