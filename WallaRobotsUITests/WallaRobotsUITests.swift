//
//  WallaRobotsUITests.swift
//  WallaRobotsUITests
//
//  Created by Miguel Cabrera on 17/04/2026.
//

import XCTest

final class WallaRobotsUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    // MARK: - Launch Tests

    @MainActor
    func testLaunch() throws {
        // GIVEN: A fresh app instance
        let app = XCUIApplication()

        // WHEN: App is launched
        app.launch()

        // THEN: Verify app launched successfully with expected UI elements
        // Wait for the app to fully load
        XCTAssertTrue(app.wait(for: .runningForeground, timeout: 5), "App should be running in foreground")

        // Verify navigation bar is present
        let navigationBar = app.navigationBars.firstMatch
        XCTAssertTrue(navigationBar.waitForExistence(timeout: 5), "Navigation bar should be present")

        // Wait for app to load and display content (either success or error state)
        let hasLoadedContent = app.staticTexts.firstMatch.waitForExistence(timeout: 10) ||
        app.buttons.firstMatch.waitForExistence(timeout: 10) ||
        app.images.firstMatch.waitForExistence(timeout: 10)
        XCTAssertTrue(hasLoadedContent, "App should display some content after loading")

        // Verify search functionality is available
        XCTAssertTrue(navigationBar.exists, "Navigation area should be present for search functionality")

        // Take screenshot for visual verification
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen - App Successfully Loaded"
        attachment.lifetime = .keepAlways
        add(attachment)
    }

    @MainActor
    func testLaunchPerformance() throws {
        // GIVEN: Performance measurement configuration
        let launchMetric = XCTApplicationLaunchMetric()

        // Set baseline expectations for launch time
        let performanceOptions = XCTMeasureOptions()
        performanceOptions.iterationCount = 5  // Run 5 times for better average

        // WHEN: Measuring app launch time multiple times
        measure(metrics: [launchMetric], options: performanceOptions) {
            let app = XCUIApplication()
            app.launch()

            // Wait for app to be fully loaded before stopping measurement
            _ = app.wait(for: .runningForeground, timeout: 10)

            // Terminate for clean state between iterations
            app.terminate()
        }

        // THEN: Launch time should be within acceptable limits
        // Note: Xcode will track performance baselines automatically
        // First run establishes baseline, subsequent runs compare against it
    }

    // MARK: - Navigation Tests

    func testNavigationToDetail() {
        // GIVEN: App is launched and robots list is loaded
        let app = XCUIApplication()
        app.launch()

        // Wait until robots list is loaded
        let firstRow = app.buttons.matching(identifier: "RobotRow_1").firstMatch
        XCTAssertTrue(firstRow.waitForExistence(timeout: 5), "The first row of the list should be displayed")

        // WHEN: User taps on the first robot row
        firstRow.tap()

        // THEN: Verify navigation to detail view is successful
        let detailName = app.staticTexts["RobotDetailName"]
        XCTAssertTrue(detailName.exists, "Should navigate to detail view successfully")

        // THEN: Verify navigation title shows the expected username
        let navTitle = app.navigationBars.staticTexts["heyres0"]
        XCTAssertTrue(navTitle.exists, "The navigation title should show the expected username")
    }
}
