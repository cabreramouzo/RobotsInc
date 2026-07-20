//
//  RobotPersistenceTests.swift
//  RobotsIncTests
//
//  Created by Miguel Cabrera on 20/07/2026.
//

import Foundation
import Testing
@testable import RobotsInc

/// In-memory local data source double, so persistence tests never touch disk.
actor InMemoryLocalDataSource: RobotLocalDataSourceProtocol {
    private(set) var stored: [RobotDTO]
    private(set) var saveCallCount = 0

    init(seed: [RobotDTO] = []) {
        self.stored = seed
    }

    func save(_ robots: [RobotDTO]) async throws {
        stored = robots
        saveCallCount += 1
    }

    func load() async throws -> [RobotDTO] {
        stored
    }
}

struct RobotPersistenceTests {

    @Test("A successful fetch writes the data through to the local cache")
    @MainActor
    func testFetchSavesToLocalCache() async throws {
        let remote = FakeRobotDataSource()
        remote.result = .success(FakeRobotDataSource.loadMockDTOs())
        let local = InMemoryLocalDataSource()
        let repository = RobotRepository(dataSource: remote, localDataSource: local)

        _ = try await repository.fetch()

        let savedCount = await local.saveCallCount
        let stored = await local.stored
        #expect(savedCount == 1, "A successful fetch should persist once")
        #expect(!stored.isEmpty, "The fetched robots should be cached to disk")
    }

    @Test("When remote fails, fetch falls back to the persisted cache")
    @MainActor
    func testFetchFallsBackToCacheOffline() async throws {
        let seed = FakeRobotDataSource.loadMockDTOs()
        let remote = FakeRobotDataSource()
        remote.result = .failure(.networkNotConnected)
        let local = InMemoryLocalDataSource(seed: seed)
        let repository = RobotRepository(dataSource: remote, localDataSource: local)

        let robots = try await repository.fetch()

        #expect(robots.count == seed.count, "Offline fetch should return the cached robots")
    }

    @Test("When remote fails and there is no cache, fetch surfaces the error")
    @MainActor
    func testFetchFailsWhenRemoteFailsAndNoCache() async {
        let remote = FakeRobotDataSource()
        remote.result = .failure(.networkNotConnected)
        let local = InMemoryLocalDataSource() // empty
        let repository = RobotRepository(dataSource: remote, localDataSource: local)

        await #expect(throws: RobotRepositoryError.network) {
            _ = try await repository.fetch()
        }
    }
}
