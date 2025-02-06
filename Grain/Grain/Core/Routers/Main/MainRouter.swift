import SwiftUI
import AppCore

@MainActor @Observable
final class MainRouter: Router {
    private let viewModel: MainViewModel

    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
    }

    var path = NavigationPath()

    @ViewBuilder
    func view(for route: any Route, completion: (() -> Void)? = nil) -> some View {
        if let route = route as? MainRoute {
            switch route {
            case let .gallery(type):
                GalleryView(type: type)
                    .environment(viewModel)
            case .settings:
                SettingsView(currentAppId: 6741040418)
            case .blendMode:
                BlendModeView()
            }
        }
    }
}
