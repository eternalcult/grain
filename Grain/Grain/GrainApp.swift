import AppCore
import Firebase
import SwiftData
import SwiftUI

@main
struct GrainApp: App {
    // MARK: Computed Properties
    @AppStorage("hasLaunchedBefore") private var hasLaunchedBefore: Bool = false
    @State var fromOnboardingToMain: Bool = false

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                if hasLaunchedBefore {
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
                } else {
                    onboardingView
                }
            }
        }
    }

    var onboardingView: some View {
        OnboardingView(pages: [
            .init(imageName: "Onboarding/onboarding1", title: "Welcome to Grain!", description: "Start enhancing your photos with easy-to-use tools and intuitive controls. Grain gives you the power to make your photos look exactly the way you envision them."),
            .init(imageName: "Onboarding/onboarding2", title: "All-in-One Photo Editing", description: "From exposure adjustments to creative filters. Grain has everything you need to transform your photos. Enhance, perfect, and personalize every image with just a few taps!"),
            .init(imageName: "Onboarding/onboarding3", title: "100% Free to Use!", description: "No subscriptions, no hidden fees—Grain is completely free. Enjoy full access to all our powerful photo editing tools without any cost!")

        ],
                       settings: .init(didTapNextButton: { isLastSlide in
            if isLastSlide {
                fromOnboardingToMain = isLastSlide
                hasLaunchedBefore = true
            }
        }, didTapCloseButton: {
            fromOnboardingToMain = true
            hasLaunchedBefore = true
        })
        ).navigationDestination(isPresented: $fromOnboardingToMain) {
            MainView()
        }
    }

    // MARK: Lifecycle

    init() {
        Font.registerFonts()
        FirebaseApp.configure()
    }
}
