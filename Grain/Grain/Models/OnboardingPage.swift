import Foundation

// MARK: - OnboardingPage

struct OnboardingPage: Hashable {
    // MARK: Properties

    let id = UUID()
    let imageName: String?
    let title: String
    let description: String?

    // MARK: Lifecycle

    init(imageName: String? = nil, title: String, description: String? = nil) {
        self.imageName = imageName
        self.title = title
        self.description = description
    }
}
