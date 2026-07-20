//
//  RobotLocalDataSourceProtocol.swift
//  RobotsInc
//
//  Created by Miguel Cabrera on 20/07/2026.
//

/// Local persistence for robots, so data survives across app sessions
/// and can be served when the network is unavailable.
protocol RobotLocalDataSourceProtocol: Sendable {
    func save(_ robots: [RobotDTO]) async throws
    func load() async throws -> [RobotDTO]
}

/// No-op implementation used as the default when persistence isn't wired
/// (previews, unit tests of pure logic). Keeps the repository init simple.
struct NullRobotLocalDataSource: RobotLocalDataSourceProtocol {
    func save(_ robots: [RobotDTO]) async throws {}
    func load() async throws -> [RobotDTO] { [] }
}
