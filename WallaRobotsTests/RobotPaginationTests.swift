//
//  RobotPaginationTests.swift
//  WallaRobots
//
//  Created by Miguel Cabrera on 19/04/2026.
//

import XCTest
@testable import WallaRobots

final class RobotPaginationTests: XCTestCase {

    @MainActor
    func testLoadMoreRobotsIncrementsList() async throws {
        // GIVEN
        let viewModel = RobotViewModel()
        await viewModel.initialLoad() // Loads first 20 robots
        let initialCount = viewModel.robots.count

        // WHEN
        viewModel.loadMoreRobots()

        // THEN
        XCTAssertEqual(viewModel.robots.count, initialCount + 20, "The array should be increased by 20 elements")
        XCTAssertEqual(viewModel.currentPage, 2)
    }
}



