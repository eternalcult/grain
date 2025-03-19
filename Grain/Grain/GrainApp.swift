import AppCore
import Firebase
import SwiftData
import SwiftUI

@main
struct GrainApp: App {
    // MARK: SwiftUI Properties

    @AppStorage("launchCounter") private var launchCounter: Int = 0
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
            .onAppear {
                launchCounter += 1
                askReviewIfNeeded()
            }
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

    // MARK: Functions

    func askReviewIfNeeded() {
        if launchCounter == 5 || launchCounter == 20 || launchCounter == 50 || launchCounter == 100 {
            AppService.askReview()
        }
    }
}
