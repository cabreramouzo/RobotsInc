//
//  RobotPaginationTests.swift
//  RobotsInc
//
//  Created by Miguel Cabrera on 19/04/2026.
//

import XCTest
@testable import RobotsInc

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

    @MainActor
    func testLastRowAppearingLoadsNextPage() async throws {
        // GIVEN: A viewModel with the first page loaded
        let viewModel = try await makeLoadedViewModel()
        let initialCount = viewModel.robots.count
        let lastVisible = try XCTUnwrap(viewModel.filteredRobots.last)

        // WHEN: The last visible row appears on screen
        viewModel.onRowAppeared(lastVisible)

        // THEN: The next page should be loaded
        XCTAssertEqual(viewModel.robots.count, initialCount + 20, "Reaching the last row should load the next page")
    }

    @MainActor
    func testMiddleRowAppearingDoesNotLoadNextPage() async throws {
        // GIVEN: A viewModel with the first page loaded
        let viewModel = try await makeLoadedViewModel()
        let initialCount = viewModel.robots.count
        let firstVisible = try XCTUnwrap(viewModel.filteredRobots.first)

        // WHEN: A row that is not the last one appears on screen
        viewModel.onRowAppeared(firstVisible)

        // THEN: No pagination should be triggered
        XCTAssertEqual(viewModel.robots.count, initialCount, "A non-last row should not trigger pagination")
    }

    @MainActor
    func testRowAppearingDuringSearchDoesNotLoadNextPage() async throws {
        // GIVEN: A viewModel with the first page loaded and an active search
        let viewModel = try await makeLoadedViewModel()
        let initialCount = viewModel.robots.count
        viewModel.searchText = "a"
        viewModel.debouncedSearchText = "a"
        let lastVisible = try XCTUnwrap(viewModel.filteredRobots.last)

        // WHEN: The last filtered row appears on screen
        viewModel.onRowAppeared(lastVisible)

        // THEN: No pagination should be triggered while searching
        XCTAssertEqual(viewModel.robots.count, initialCount, "Pagination should be disabled while a search is active")
    }

    // MARK: - Helpers

    @MainActor
    private func makeLoadedViewModel() async throws -> RobotViewModel {
        let mockDataSource = FakeRobotDataSource()
        mockDataSource.result = .success(FakeRobotDataSource.loadMockDTOs())
        let viewModel = RobotViewModel(repository: RobotRepository(dataSource: mockDataSource))
        await viewModel.initialLoad()
        return viewModel
    }
}
