//
//  RobotService.swift
//  WallaRobots
//
//  Created by Miguel Cabrera on 19/04/2026.
//

import Foundation

private enum APIConfig {
    private static let baseURL = "https://acoding.academy/testData"

    enum Endpoint {
        static let robots = "\(APIConfig.baseURL)/EmpleadosData.json"
    }
}

final class RobotRemoteDataSource: RobotDataSourceProtocol {

    private func fetchRobotsFromAPI() async throws -> [RobotDTO] {
        guard let url = URL(string: APIConfig.Endpoint.robots) else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        let decoder = JSONDecoder()
        return try decoder.decode([RobotDTO].self, from: data)
    }

    func fetch() async throws -> [RobotDTO] {
        return try await fetchRobotsFromAPI()
    }
}
