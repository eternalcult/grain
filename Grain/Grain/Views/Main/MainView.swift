
import AppCore
import SwiftUI

struct MainView: View {
    // MARK: SwiftUI Properties
    @State private var router: MainRouter
    @State private var viewModel = MainViewModel()

    init(viewModel: MainViewModel = MainViewModel()) {
        self.viewModel = viewModel
        self.router = MainRouter(viewModel: viewModel)
    }

    // MARK: Content Properties

    var body: some View {
        NavigationStack(path: $router.path) {
            VStack(spacing: 8) {
                MainHeaderView(with: viewModel)
                    .environment(router)
                if let sourceImage = viewModel.sourceImage, let finalImage = viewModel.finalImage {
                    PhotoEditorView(sourceImage, finalImage, with: viewModel)
                        .environment(router)
                } else {
                    MainPhotoPickerView(with: viewModel)
                }
            }
            .padding(.horizontal, 8)
            .background(Color.background)
            .navigationBarBackButtonHidden(true)
            .onChange(of: viewModel.errorMessage) { _, newError in
                if newError != nil {
                    viewModel.showErrorAlert = true
                }
            }
            .failureBlackAlert($viewModel.showErrorAlert, message: viewModel.errorMessage, duration: 3)
            .navigationDestination(for: MainRoute.self) { route in
                router.view(for: route).environment(router)
            }
        }
    }

//        .onAppear { // Only for testing
//            if let uiImage = UIImage(named: "preview"),
//               let cgImage = uiImage.cgImage {
//                viewModel.photoEditor.updateSourceImage(CIImage(cgImage: cgImage), orientation: .up)
//            }
//        }
}

#Preview {
    MainView()
}
