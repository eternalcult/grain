import AppCore
import Firebase
import SwiftData
import SwiftUI

@main
struct GrainApp: App {
    // MARK: SwiftUI Properties

    @AppStorage("hasLaunchedBefore") private var hasLaunchedBefore: Bool = false

    // MARK: Computed Properties

    var body: some Scene {
        WindowGroup {
            if hasLaunchedBefore {
                mainView
            } else {
                onboardingView
            }
        }
    }

    // MARK: Lifecycle

    init() {
        Font.registerFonts()
        FirebaseApp.configure()
    }

    // MARK: Content Properties

    private var mainView: some View {
        MainView()
            .modelContainer(for: [FilterCICubeData.self]) { container in
                switch container {
                case let .success(container):
                    DataStorage.shared.addSwiftDataContext(container.mainContext)
                    DataStorage.shared.configureFiltersDataIfNeeded()

                case let .failure(failure):
                    print("Error with model container", failure.localizedDescription)
                }
            }
    }

    private var onboardingView: some View {
        OnboardingView(
            pages: DataStorage.shared.onboardingPages,
            settings: .init(didTapNextButton: { isLastSlide in
                if isLastSlide {
                    hasLaunchedBefore = true
                }
            }, didTapCloseButton: {
                hasLaunchedBefore = true
            })
        )
    }
}
