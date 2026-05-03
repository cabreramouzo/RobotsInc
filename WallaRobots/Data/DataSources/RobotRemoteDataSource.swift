//
//  RobotRemoteDataSource.swift
//  WallaRobots
//

import Foundation

private enum APIConfig {
    private static let baseURL = "https://acoding.academy/testData"

    enum Endpoint {
        static let robots = "\(APIConfig.baseURL)/EmpleadosData.json"
    }
}

final class RobotRemoteDataSource: RobotDataSourceProtocol {

    func fetch() async throws -> [RobotDTO] {
        guard let url = URL(string: APIConfig.Endpoint.robots) else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode([RobotDTO].self, from: data)
    }
}
