//
//  RobotRepository.swift
//  WallaRobots
//
//  Created by Miguel Cabrera on 01/05/2026.
//

final class RobotRepository: RobotRepositoryProtocol {
    private let dataSource: RobotDataSourceProtocol

    func fetch() async throws -> [Robot] {
        let remoteData = try await dataSource.fetch()
        return remoteData
    }

    init(dataSource: RobotDataSourceProtocol) {
        self.dataSource = dataSource
    }
}
