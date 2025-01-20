//
//  GrainApp.swift
//  Grain
//
//  Created by Vlad Antonov on 12.01.2025.
//

import SwiftUI
import SwiftData
import AppCore

@main
struct GrainApp: App {

    init() {
        Font.registerFonts()
    }

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
}
