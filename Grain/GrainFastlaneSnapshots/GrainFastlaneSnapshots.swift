//
//  GrainFastlaneSnapshots.swift
//  GrainFastlaneSnapshots
//
//  Created by Vlad Antonov on 04.02.2025.
//

import XCTest

final class GrainFastlaneSnapshots: XCTestCase {

    @MainActor
    override func setUpWithError() throws {
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
        continueAfterFailure = false
    }

    func testScreenshots() throws {
        
    }
}
