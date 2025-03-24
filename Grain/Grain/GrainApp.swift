import Factory
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
        FirebaseApp.configure()
    }

    // MARK: Content Properties

    private var mainView: some View {
        MainView()
            .onAppear {
                launchCounter += 1
                askReviewIfNeeded()
            }
    }

    private var onboardingView: some View {
        OnboardingView { finished in
            if finished {
                hasLaunchedBefore = true
            }
        }
    }

    // MARK: Functions

    func askReviewIfNeeded() {
        if launchCounter == 5 || launchCounter == 20 || launchCounter == 50 || launchCounter == 100 {
            AppService.askReview()
        }
    }
}
