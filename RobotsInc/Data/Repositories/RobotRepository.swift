//
//  RobotRepository.swift
//  RobotsInc
//
//  Created by Miguel Cabrera on 01/05/2026.
//

import OSLog

enum RobotRepositoryError: Error, Equatable {
    case network
    case server
    case notFound
    case unknown
}

final class RobotRepository: RobotRepositoryProtocol {
    private let dataSource: RobotDataSourceProtocol

    /// In-memory cache of the last successful fetch, so detail lookups
    /// coming from the list resolve instantly instead of re-fetching.
    private var cachedRobots: [Robot] = []

    func fetch() async throws(RobotRepositoryError) -> [Robot] {
        do {
            let dtos = try await dataSource.fetch()
            let robots = dtos.map { $0.toDomain() }
            cachedRobots = robots
            return robots
        } catch {
            switch error {
            case .networkNotConnected:
                throw .network
            case .server:
                throw .server
            case .decoding, .unknown:
                throw .unknown
            }
        }
    }

    func robot(withID id: Int) async throws(RobotRepositoryError) -> Robot {
        // Cold start (e.g. a deep link before the list ever loaded):
        // fetch first so the lookup has data to resolve against.
        if cachedRobots.isEmpty {
            _ = try await fetch()
        }

        guard let robot = cachedRobots.first(where: { $0.id == id }) else {
            throw .notFound
        }
        return robot
    }

    init(dataSource: RobotDataSourceProtocol) {
        self.dataSource = dataSource
    }
}
