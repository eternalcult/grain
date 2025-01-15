//
//  GrainApp.swift
//  Grain
//
//  Created by Vlad Antonov on 12.01.2025.
//

import SwiftUI
import AppCore

@main
struct GrainApp: App {

    init() {
        Font.registerFonts()
    }

    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
