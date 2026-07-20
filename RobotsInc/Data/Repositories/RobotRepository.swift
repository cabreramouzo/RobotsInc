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
    private let localDataSource: RobotLocalDataSourceProtocol

    /// In-memory cache of the last resolved fetch, so detail lookups
    /// coming from the list resolve instantly instead of re-fetching.
    private var cachedRobots: [Robot] = []

    func fetch() async throws(RobotRepositoryError) -> [Robot] {
        do {
            let dtos = try await dataSource.fetch()
            // Write-through cache: persist the fresh data for next sessions.
            try? await localDataSource.save(dtos)
            return store(dtos)
        } catch {
            // Remote failed: fall back to the persisted cache if we have one,
            // so the app still works offline / across sessions.
            if let cachedDTOs = try? await localDataSource.load(), !cachedDTOs.isEmpty {
                return store(cachedDTOs)
            }
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

    /// Maps DTOs to domain, refreshes the in-memory cache, and returns them.
    private func store(_ dtos: [RobotDTO]) -> [Robot] {
        let robots = dtos.map { $0.toDomain() }
        cachedRobots = robots
        return robots
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

    init(
        dataSource: RobotDataSourceProtocol,
        localDataSource: RobotLocalDataSourceProtocol = NullRobotLocalDataSource()
    ) {
        self.dataSource = dataSource
        self.localDataSource = localDataSource
    }
}
