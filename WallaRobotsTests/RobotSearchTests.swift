//
//  RobotSearchTests.swift
//  WallaRobots
//
//  Created by Miguel Cabrera on 19/04/2026.
//

import XCTest
import Combine
@testable import WallaRobots

final class RobotSearchTests: XCTestCase {

    @MainActor
    func testSearchFiltersRobotsByName() async {
        // GIVEN: A viewModel with mocked robots
        let mockService = FakeRobotService()
        mockService.result = .success(FakeRobotService.loadMockRobots())
        let viewModel = RobotViewModel(service: mockService)

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
        let mockService = FakeRobotService()
        mockService.result = .success(FakeRobotService.loadMockRobots())
        let viewModel = RobotViewModel(service: mockService)

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
        let mockService = FakeRobotService()
        mockService.result = .success(FakeRobotService.loadMockRobots())
        let viewModel = RobotViewModel(service: mockService)

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
        let mockService = FakeRobotService()
        mockService.result = .success(FakeRobotService.loadMockRobots())
        let viewModel = RobotViewModel(service: mockService)

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
        let mockService = FakeRobotService()
        mockService.result = .success(FakeRobotService.loadMockRobots())
        let viewModel = RobotViewModel(service: mockService)

        await viewModel.initialLoad()

        // WHEN: User searches for something that doesn't exist
        viewModel.debouncedSearchText = "ZZZZNOTFOUND"

        // THEN: filteredRobots should be empty
        XCTAssertTrue(viewModel.filteredRobots.isEmpty)
    }

    // MARK: - Debounce Tests

    @MainActor
    func testSearchDebounceDelaysUpdate() async {
        // GIVEN: A viewModel with REAL debounce (0.3s) - using default transform
        let mockService = FakeRobotService()
        mockService.result = .success(FakeRobotService.loadMockRobots())
        let viewModel = RobotViewModel(service: mockService) // Uses default debounce

        await viewModel.initialLoad()

        // WHEN: User types rapidly (simulating fast typing)
        viewModel.searchText = "H"
        viewModel.searchText = "Ha"
        viewModel.searchText = "Had"
        viewModel.searchText = "Hadl"
        viewModel.searchText = "Hadley"

        // THEN: debouncedSearchText should NOT be updated immediately
        XCTAssertEqual(viewModel.debouncedSearchText, "", "Debounce should delay the update")
    }

    @MainActor
    func testSearchDebounceWithImmediateTransform() {
        // GIVEN: A viewModel with minimal debounce (for testing)
        let mockService = FakeRobotService()
        mockService.result = .success(FakeRobotService.loadMockRobots())
        let viewModel = RobotViewModel(
            service: mockService,
            debounceInterval: 0
        )

        let expectation = XCTestExpectation(description: "Debounce updates debouncedSearchText")

        let cancellable = viewModel.$debouncedSearchText
            .dropFirst()
            .sink { value in
                if value == "Hadley" {
                    expectation.fulfill()
                }
            }

        // WHEN: User types a search term
        viewModel.searchText = "Hadley"

        // THEN: Wait for debounce to complete
        wait(for: [expectation], timeout: 1.0)

        XCTAssertEqual(viewModel.debouncedSearchText, "Hadley")

        cancellable.cancel()
    }

    @MainActor
    func testSearchDebounceOnlyFinalValueIsUsed() {
        // GIVEN: A viewModel with REAL debounce to test that intermediate values are filtered
        let mockService = FakeRobotService()
        mockService.result = .success(FakeRobotService.loadMockRobots())
        let viewModel = RobotViewModel(service: mockService, debounceInterval: 0)

        var receivedValues: [String] = []
        let expectation = XCTestExpectation(description: "Debounce emits only final value")

        let cancellable = viewModel.$debouncedSearchText
            .dropFirst() // Ignore initial empty value
            .sink { value in
                receivedValues.append(value)
                if value == "Hadley" {
                    expectation.fulfill()
                }
            }

        // WHEN: User types rapidly
        viewModel.searchText = "H"
        viewModel.searchText = "Ha"
        viewModel.searchText = "Had"
        viewModel.searchText = "Hadl"
        viewModel.searchText = "Hadley"

        // Run the RunLoop to allow debounce to complete
        RunLoop.main.run(until: Date().addingTimeInterval(0.5))

        wait(for: [expectation], timeout: 1.0)

        // THEN: Only the final value should have been emitted (debounce filters intermediate values)
        XCTAssertEqual(receivedValues.count, 1, "Debounce should only emit the final value, not intermediate ones")
        XCTAssertEqual(receivedValues.first, "Hadley")

        cancellable.cancel()
    }
}
