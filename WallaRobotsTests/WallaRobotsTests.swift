//
//  WallaRobotsTests.swift
//  WallaRobotsTests
//
//  Created by Miguel Cabrera on 17/04/2026.
//

import Testing
@testable import WallaRobots

struct WallaRobotsTests {

    @Test("Verify initial load populates robots array")
    func testInitialLoadPopulatesRobots() async throws {
        // GIVEN
        let viewModel = await RobotViewModel()

        // WHEN
        try await viewModel.initialLoad()

        // THEN
        #expect(!viewModel.robots.isEmpty)
        #expect(viewModel.robots.count == 20) // First pagination slice
    }

}
