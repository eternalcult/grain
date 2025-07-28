import SwiftUI

struct MainView: View {
    // MARK: SwiftUI Properties

    @State private var router: MainRouter
    @State private var viewModel: MainViewModel

    // MARK: Lifecycle

    init(viewModel: MainViewModel = MainViewModel()) {
        self.viewModel = viewModel
        router = MainRouter(viewModel: viewModel)
    }

    // MARK: Content Properties

    var body: some View {
        NavigationStack(path: $router.path) {
            VStack(spacing: .s) {
                if viewModel.sourceImage != nil {
                    VStack(spacing: .none) {
                        MainHeaderView(with: viewModel)
                            .environment(router)
                        PhotoEditorView()
                            .environment(router)
                            .environment(viewModel)
                    }
                    .padding(.horizontal, .s)
                } else {
                    MainPhotoPickerView(with: viewModel)
                }
            }
            .background(Color.background)
            .navigationBarBackButtonHidden(true)
            .onChange(of: viewModel.errorMessage) { _, newError in
                viewModel.showErrorAlert = newError != nil
            }
            .failureAlert($viewModel.showErrorAlert, message: viewModel.errorMessage, duration: 3)
            .navigationDestination(for: MainRoute.self) { route in
                router.view(for: route).environment(router)
            }
        }
    }
}

#Preview {
    MainView()
}
