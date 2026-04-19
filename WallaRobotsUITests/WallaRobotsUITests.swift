//
//  WallaRobotsUITests.swift
//  WallaRobotsUITests
//
//  Created by Miguel Cabrera on 17/04/2026.
//

import XCTest

final class WallaRobotsUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

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
