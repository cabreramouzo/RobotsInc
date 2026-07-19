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
    case unknown
}

final class RobotRepository: RobotRepositoryProtocol {
    private let dataSource: RobotDataSourceProtocol

    func fetch() async throws(RobotRepositoryError) -> [Robot] {
        do {
            let dtos = try await dataSource.fetch()
            return dtos.map { $0.toDomain() }
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

    init(dataSource: RobotDataSourceProtocol) {
        self.dataSource = dataSource
    }
}
