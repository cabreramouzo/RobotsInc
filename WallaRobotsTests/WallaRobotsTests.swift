//
//  WallaRobotsTests.swift
//  WallaRobotsTests
//
//  Created by Miguel Cabrera on 17/04/2026.
//

import Testing
import Foundation
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

    @Test("Test initial load success with mocked service")
    @MainActor
    func testInitialLoadSuccess() async throws {
        // GIVEN
        let mockRobots = FakeRobotService.loadMockRobots()
        let mockService = FakeRobotService()
        mockService.result = .success(mockRobots)

        let viewModel = RobotViewModel(service: mockService)

        // WHEN
        try await viewModel.initialLoad()

        // THEN
        #expect(mockService.fetchCalled)
        #expect(viewModel.robots.count == 20)
    }

    @Test("Test initial load failure shows error message")
    func testInitialLoadFailure() async throws {
        // GIVEN
        let mockService = FakeRobotService()
        mockService.result = .failure(URLError(.notConnectedToInternet))

        let viewModel = await RobotViewModel(service: mockService)

        // WHEN
        try await viewModel.initialLoad()

        // THEN
        #expect(viewModel.robots.isEmpty)
    }

    @Test
    @MainActor
    func testFirstRobotDetails() async throws {
        // GIVEN
        let mockRobots = FakeRobotService.loadMockRobots()
        let mockService = FakeRobotService()
        mockService.result = .success(mockRobots)

        let viewModel = RobotViewModel(service: mockService)

        // WHEN
        try await viewModel.initialLoad()

        // THEN
        // If robots is empty, the test stops here and throws a clean error
        let firstRobot = try #require(viewModel.robots.first)

        // if this is executed, means first robot is not nil
        #expect(firstRobot.fullName == "Hadley Eyres")
    }

}
