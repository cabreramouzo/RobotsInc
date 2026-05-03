//
//  RobotSearchTests.swift
//  WallaRobots
//
//  Created by Miguel Cabrera on 19/04/2026.
//

import XCTest
@testable import WallaRobots

final class RobotSearchTests: XCTestCase {

    @MainActor
    func testSearchFiltersRobotsByName() async {
        // GIVEN: A viewModel with mocked robots
        let mockDataSource = FakeRobotDataSource()
        mockDataSource.result = .success(FakeRobotDataSource.loadMockDTOs())
        let viewModel = RobotViewModel(repository: RobotRepository(dataSource: mockDataSource))

        await viewModel.initialLoad()

        let initialCount = viewModel.robots.count
        XCTAssertGreaterThan(initialCount, 0, "Should have robots loaded")

        // WHEN: User searches for a specific name
        let robotToFind = "Hadley"
        viewModel.searchText = robotToFind

        // Manually trigger debounce for testing (simulate debounce completion)
        viewModel.debouncedSearchText = robotToFind

        // THEN: filteredRobots should only contain matching results
        XCTAssertTrue(viewModel.filteredRobots.allSatisfy {
            $0.fullName.localizedCaseInsensitiveContains(robotToFind)
        }, "filteredRobots should only contain robots matching the search")
    }

    @MainActor
    func testSearchWithEmptyTextReturnsAllRobots() async {
        // GIVEN: A viewModel with mocked robots
        let mockDataSource = FakeRobotDataSource()
        mockDataSource.result = .success(FakeRobotDataSource.loadMockDTOs())
        let viewModel = RobotViewModel(repository: RobotRepository(dataSource: mockDataSource))

        await viewModel.initialLoad()

        let initialCount = viewModel.robots.count

        // WHEN: Search text is empty
        viewModel.searchText = ""
        viewModel.debouncedSearchText = ""

        // THEN: filteredRobots returns all robots
        XCTAssertEqual(viewModel.filteredRobots.count, initialCount)
    }

    @MainActor
    func testSearchByEmail() async {
        // GIVEN: A viewModel with mocked robots
        let mockDataSource = FakeRobotDataSource()
        mockDataSource.result = .success(FakeRobotDataSource.loadMockDTOs())
        let viewModel = RobotViewModel(repository: RobotRepository(dataSource: mockDataSource))

        await viewModel.initialLoad()

        // WHEN: User searches by email
        let emailToFind = "heyres0@mozilla.org"
        viewModel.debouncedSearchText = emailToFind

        // THEN: Should find the robot with that email
        XCTAssertEqual(viewModel.filteredRobots.count, 1)
        XCTAssertEqual(viewModel.filteredRobots.first?.email, emailToFind)
    }

    @MainActor
    func testSearchByUsername() async {
        // GIVEN: A viewModel with mocked robots
        let mockDataSource = FakeRobotDataSource()
        mockDataSource.result = .success(FakeRobotDataSource.loadMockDTOs())
        let viewModel = RobotViewModel(repository: RobotRepository(dataSource: mockDataSource))

        await viewModel.initialLoad()

        // WHEN: User searches by username
        let usernameToFind = "heyres0"
        viewModel.debouncedSearchText = usernameToFind

        // THEN: Should find the robot with that username
        XCTAssertTrue(viewModel.filteredRobots.allSatisfy {
            $0.username.localizedCaseInsensitiveContains(usernameToFind)
        })
    }

    @MainActor
    func testSearchNoResults() async {
        // GIVEN: A viewModel with mocked robots
        let mockDataSource = FakeRobotDataSource()
        mockDataSource.result = .success(FakeRobotDataSource.loadMockDTOs())
        let viewModel = RobotViewModel(repository: RobotRepository(dataSource: mockDataSource))

        await viewModel.initialLoad()

        // WHEN: User searches for something that doesn't exist
        viewModel.debouncedSearchText = "ZZZZNOTFOUND"

        // THEN: filteredRobots should be empty
        XCTAssertTrue(viewModel.filteredRobots.isEmpty)
    }

    // MARK: - Debounce Tests
    // Note: The debounce logic lives in RobotListView via .task(id: viewModel.searchText)
    // These tests verify the ViewModel behavior when debouncedSearchText is updated by the View

    @MainActor
    func testSearchTextDoesNotImmediatelyUpdateFilteredRobots() async {
        // GIVEN: A viewModel with mocked robots
        let mockDataSource = FakeRobotDataSource()
        mockDataSource.result = .success(FakeRobotDataSource.loadMockDTOs())
        let viewModel = RobotViewModel(repository: RobotRepository(dataSource: mockDataSource))

        await viewModel.initialLoad()
        let initialCount = viewModel.filteredRobots.count

        // WHEN: searchText changes (simulating user typing, before the View's debounce fires)
        viewModel.searchText = "Hadley"

        // THEN: filteredRobots should NOT change yet - debouncedSearchText is still empty
        XCTAssertEqual(viewModel.debouncedSearchText, "", "View hasn't fired debounce yet")
        XCTAssertEqual(
            viewModel.filteredRobots.count,
            initialCount,
            "filteredRobots should not change until debouncedSearchText is updated"
        )
    }

    @MainActor
    func testDebouncedSearchTextUpdatesFilteredRobots() async {
        // GIVEN: A viewModel with mocked robots
        let mockDataSource = FakeRobotDataSource()
        mockDataSource.result = .success(FakeRobotDataSource.loadMockDTOs())
        let viewModel = RobotViewModel(repository: RobotRepository(dataSource: mockDataSource))

        await viewModel.initialLoad()

        // WHEN: The View fires the debounce and updates debouncedSearchText (simulating .task(id:))
        viewModel.searchText = "Hadley"
        viewModel.debouncedSearchText = viewModel.searchText  // simulates View's .task(id:) completion

        // THEN: filteredRobots should now be filtered
        XCTAssertFalse(viewModel.filteredRobots.isEmpty, "Should have results for 'Hadley'")
        XCTAssertTrue(viewModel.filteredRobots.allSatisfy {
            $0.fullName.localizedCaseInsensitiveContains("Hadley")
        }, "filteredRobots should only contain robots matching 'Hadley'")
    }

    @MainActor
    func testOnlyFinalDebouncedValueAffectsFilteredRobots() async {
        // GIVEN: A viewModel with mocked robots
        let mockDataSource = FakeRobotDataSource()
        mockDataSource.result = .success(FakeRobotDataSource.loadMockDTOs())
        let viewModel = RobotViewModel(repository: RobotRepository(dataSource: mockDataSource))

        await viewModel.initialLoad()

        // WHEN: User types rapidly (intermediate values never reach debouncedSearchText)
        // and only the final value is committed by the View's debounce
        viewModel.searchText = "H"
        viewModel.searchText = "Ha"
        viewModel.searchText = "Had"
        viewModel.searchText = "Hadl"
        viewModel.searchText = "Hadley"
        viewModel.debouncedSearchText = viewModel.searchText  // only final value committed

        // THEN: filteredRobots reflects only the final search value
        XCTAssertTrue(viewModel.filteredRobots.allSatisfy {
            $0.fullName.localizedCaseInsensitiveContains("Hadley")
        }, "Only the final debounced value should affect filteredRobots")
    }
}
