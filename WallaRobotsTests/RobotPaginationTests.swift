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

        // GIVEN: A viewModel with initial robots loaded
        let mockDataSource = FakeRobotDataSource()
        mockDataSource.result = .success(FakeRobotDataSource.loadMockDTOs())
        let viewModel = RobotViewModel(repository: RobotRepository(dataSource: mockDataSource))
        await viewModel.initialLoad() // Loads first 20 robots
        let initialCount = viewModel.robots.count

        // WHEN: User requests to load more robots
        viewModel.loadMoreRobots()

        // THEN: Robot count should increase and page should increment
        XCTAssertEqual(viewModel.robots.count, initialCount + 20, "The array should be increased by 20 elements")
        XCTAssertEqual(viewModel.currentPage, 2, "Should be on page 2 after pagination")
    }
}
