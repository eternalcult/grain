import XCTest

final class GrainFastlaneSnapshots: XCTestCase {
    // MARK: Overridden Functions

    @MainActor
    override func setUpWithError() throws {
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
        continueAfterFailure = false
    }

    // MARK: Functions

    func testScreenshots() throws {}
}
