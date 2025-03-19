import XCTest

final class GrainFastlaneSnapshotsLaunchTests: XCTestCase {
    // MARK: Overridden Properties

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    // MARK: Overridden Functions

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    // MARK: Functions

    @MainActor
    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
