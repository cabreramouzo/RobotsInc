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
    @MainActor
    func testInitialLoadPopulatesRobots() async {
        // GIVEN: A fresh viewModel with default service
        let viewModel = RobotViewModel()

        // WHEN: Initial load is triggered
        await viewModel.initialLoad()

        // THEN: Robots array should be populated with first page
        #expect(!viewModel.robots.isEmpty, "Robots array should not be empty after initial load")
        #expect(viewModel.robots.count == 20, "Should load first pagination slice of 20 robots")
    }

    @Test("Test initial load success with mocked service")
    @MainActor
    func testInitialLoadSuccess() async {
        // GIVEN: A viewModel with mocked service configured for success
        let mockRobots = FakeRobotService.loadMockRobots()
        let mockService = FakeRobotService()
        mockService.result = .success(mockRobots)

        let viewModel = RobotViewModel(service: mockService)

        // WHEN: Initial load is triggered
        await viewModel.initialLoad()

        // THEN: Service should be called and robots should be loaded
        #expect(mockService.fetchCalled, "Mock service should have been called")
        #expect(viewModel.robots.count == 20, "Should load first page of 20 robots")
    }


    @Test("Test initial load failure shows error message")
    @MainActor
    func testInitialLoadFailure() async {
        // GIVEN: A viewModel with mocked service configured to fail
        let mockService = FakeRobotService()
        mockService.result = .failure(URLError(.notConnectedToInternet))

        let viewModel = RobotViewModel(service: mockService)

        // WHEN: Initial load is triggered
        await viewModel.initialLoad()

        // THEN: Robots array should remain empty due to failure
        #expect(viewModel.robots.isEmpty, "Robots array should remain empty when load fails")
    }

    @Test("Test first robot details are correctly loaded")
    @MainActor
    func testFirstRobotDetails() async throws {
        // GIVEN: A viewModel with mocked service containing test data
        let mockRobots = FakeRobotService.loadMockRobots()
        let mockService = FakeRobotService()
        mockService.result = .success(mockRobots)

        let viewModel = RobotViewModel(service: mockService)

        // WHEN: Initial load is triggered
        await viewModel.initialLoad()
        
        // THEN: First robot should have expected details
        let firstRobot = try #require(viewModel.robots.first, "Should have at least one robot loaded")
        #expect(firstRobot.fullName == "Hadley Eyres", "First robot should be Hadley Eyres")
    }

}
