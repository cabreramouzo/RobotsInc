//
//  RobotDetailTests.swift
//  RobotsIncTests
//
//  Created by Miguel Cabrera on 19/07/2026.
//

import Foundation
import Testing
@testable import RobotsInc

struct RobotDetailTests {

    // MARK: - Repository lookup

    @Test("Robot lookup resolves from a cold start without loading the list first")
    @MainActor
    func testLookupOnColdStartFetches() async throws {
        let dataSource = FakeRobotDataSource()
        dataSource.result = .success(FakeRobotDataSource.loadMockDTOs())
        let repository = RobotRepository(dataSource: dataSource)

        // No previous fetch(): simulates arriving via deep link with the app cold.
        let robot = try await repository.robot(withID: 1)

        #expect(robot.id == 1)
        #expect(dataSource.fetchCalled, "A cold lookup should fetch the data source")
    }

    @Test("Robot lookup throws .notFound for an unknown id")
    @MainActor
    func testLookupUnknownIDThrowsNotFound() async throws {
        let dataSource = FakeRobotDataSource()
        dataSource.result = .success(FakeRobotDataSource.loadMockDTOs())
        let repository = RobotRepository(dataSource: dataSource)

        await #expect(throws: RobotRepositoryError.notFound) {
            _ = try await repository.robot(withID: -999)
        }
    }

    // MARK: - Detail view model

    @Test("Detail view model exposes the robot after a successful load")
    @MainActor
    func testDetailViewModelLoadsRobot() async throws {
        let dataSource = FakeRobotDataSource()
        dataSource.result = .success(FakeRobotDataSource.loadMockDTOs())
        let repository = RobotRepository(dataSource: dataSource)
        let viewModel = RobotDetailViewModel(robotID: 1, repository: repository)

        await viewModel.load()

        #expect(viewModel.robot?.id == 1)
        #expect(viewModel.error == nil)
        #expect(viewModel.errorViewData == nil)
    }

    @Test("Detail view model surfaces .notFound as error view data")
    @MainActor
    func testDetailViewModelNotFound() async throws {
        let dataSource = FakeRobotDataSource()
        dataSource.result = .success(FakeRobotDataSource.loadMockDTOs())
        let repository = RobotRepository(dataSource: dataSource)
        let viewModel = RobotDetailViewModel(robotID: -999, repository: repository)

        await viewModel.load()

        #expect(viewModel.robot == nil)
        #expect(viewModel.error == .notFound)
        #expect(viewModel.errorViewData != nil)
    }

    // MARK: - Deep link parsing

    @Test("Valid deep link URL resolves to a robot id")
    func testDeepLinkValidURL() throws {
        let url = try #require(URL(string: "robotsinc://robot/42"))
        #expect(DeepLink.robotID(from: url) == 42)
    }

    @Test("Invalid deep link URLs are rejected", arguments: [
        "robotsinc://user/42",
        "otherapp://robot/42",
        "robotsinc://robot/notAnID",
        "robotsinc://robot"
    ])
    func testDeepLinkInvalidURLs(urlString: String) throws {
        let url = try #require(URL(string: urlString))
        #expect(DeepLink.robotID(from: url) == nil)
    }
}
