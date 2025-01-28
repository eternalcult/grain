import AppCore
import SwiftData
import SwiftUI
import Firebase

@main
struct GrainApp: App {
    // MARK: Computed Properties

    var body: some Scene {
        WindowGroup {
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
    }

    // MARK: Lifecycle

    init() {
        Font.registerFonts()
        FirebaseApp.configure()
    }
}
