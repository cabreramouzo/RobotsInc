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
    func testSearchDebounceWorks() async throws {
        // GIVEN:
        let viewModel = RobotViewModel()

        try await viewModel.initialLoad()

        let robotToFind = viewModel.robots.first?.fullName ?? ""

        // WHEN: Type in the search bar
        viewModel.searchText = robotToFind

        // THEN:
        XCTAssertNotEqual(viewModel.filteredRobots.count, 1, "The filter should not be applied immediately")

        // debounce is 0.3 seconds, let's wait a little more.
        try await Task.sleep(nanoseconds: 500_000_000)

        XCTAssertTrue(viewModel.filteredRobots.allSatisfy {
            $0.fullName.localizedCaseInsensitiveContains(robotToFind)
        }, "Filter exceuted, filteredRobots should only contain the matched results")
    }
}
