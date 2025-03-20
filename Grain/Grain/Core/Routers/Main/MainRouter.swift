import SwiftUI

@MainActor @Observable
final class MainRouter: Router {
    // MARK: Properties

    var path = NavigationPath()

    private let viewModel: MainViewModel

    // MARK: Lifecycle

    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
    }

    // MARK: Content Methods

    @ViewBuilder
    func view(for route: any Route, completion _: (() -> Void)? = nil) -> some View {
        if let route = route as? MainRoute {
            switch route {
            case let .gallery(type):
                GalleryView(type: type)
                    .environment(viewModel)

            case .settings:
                SettingsView(currentAppId: 6_741_040_418)

            case .blendMode:
                BlendModeView()
            }
        }
    }
}
