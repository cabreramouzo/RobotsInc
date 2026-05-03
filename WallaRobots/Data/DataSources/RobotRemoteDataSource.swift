//
//  RobotRemoteDataSource.swift
//  WallaRobots
//
//  Created by Miguel Cabrera on 03/05/2026.
//

import Foundation

// MARK: - API Configuration

private enum APIConfig {
    static let baseURL = "https://acoding.academy/testData"

    enum Endpoint {
        static let robots: URL = URL(string: "\(APIConfig.baseURL)/EmpleadosData.json")!
    }
}

// MARK: - Remote DataSource

final class RobotRemoteDataSource: RobotDataSourceProtocol {

    private let session: URLSessionProtocol

    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }

    func fetch() async throws -> [RobotDTO] {
        try await fetchDecodable([RobotDTO].self, from: APIConfig.Endpoint.robots)
    }

    // MARK: - Generic Network Layer

    private func fetchDecodable<T: Decodable>(_ type: T.Type, from url: URL) async throws -> T {
        let (data, response) = try await session.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode(T.self, from: data)
    }
}
