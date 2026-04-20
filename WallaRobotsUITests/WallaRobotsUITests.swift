//
//  WallaRobotsUITests.swift
//  WallaRobotsUITests
//
//  Created by Miguel Cabrera on 17/04/2026.
//

import XCTest

final class WallaRobotsUITests: XCTestCase {

    @MainActor
    func testLaunchPerformance() throws {
        // This measures how long it takes to launch your application.
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }

    func testNavigationToDetail() {
        let app = XCUIApplication()
        app.launch()

        // GIVEN: Wait until robots list loaded
        let firstRow = app.buttons.matching(identifier: "RobotRow_1").firstMatch

        XCTAssertTrue(firstRow.waitForExistence(timeout: 5), "The firt row of the list isn't showed")

        // WHEN
        firstRow.tap()

        // THEN:
        let detailName = app.staticTexts["RobotDetailName"]
        XCTAssertTrue(detailName.exists, " Can't navigate to detail view")

        // THEN2:
        let navTitle = app.navigationBars.staticTexts["heyres0"]
        XCTAssertTrue(navTitle.exists, "The navigation title does not show the expected username")
    }
}
