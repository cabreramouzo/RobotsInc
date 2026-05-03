//
//  RobotRemoteDataSource.swift
//  WallaRobots
//
// Created by Miguel Cabrera on 03/05/2026.
//

import Foundation

// MARK: - Remote DataSource

private enum Endpoint {
    static let robots: URL = URL(string: "https://acoding.academy/testData/EmpleadosData.json")!
}

final class RobotRemoteDataSource: RobotDataSourceProtocol {

    private let session: URLSessionProtocol

    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }

    func fetch() async throws -> [RobotDTO] {
        let (data, response) = try await session.data(from: Endpoint.robots)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode([RobotDTO].self, from: data)
    }
}
