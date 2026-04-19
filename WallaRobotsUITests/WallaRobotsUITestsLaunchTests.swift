//
//  WallaRobotsUITestsLaunchTests.swift
//  WallaRobotsUITests
//
//  Created by Miguel Cabrera on 17/04/2026.
//

import XCTest

final class WallaRobotsUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

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

    func testNavigationToDetail() {
        let app = XCUIApplication()
        app.launch()

        // GIVEN: Wait until robots list loaded
        let firstRow = app.buttons.matching(identifier: "RobotRow_1").firstMatch

        XCTAssertTrue(firstRow.waitForExistence(timeout: 5), "The firt row of the list isn't showed")

        // WHEN
        firstRow.tap()

        // THEN: Verify we are in the deail view
        let detailName = app.staticTexts["RobotDetailName"]
        XCTAssertTrue(detailName.exists, " Can't navigate to detail view")

    }

}
