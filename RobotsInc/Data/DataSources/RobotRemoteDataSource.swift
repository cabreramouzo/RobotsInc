//
//  RobotRemoteDataSource.swift
//  RobotsInc
//
// Created by Miguel Cabrera on 03/05/2026.
//

import Foundation
import OSLog

// MARK: - Remote DataSource

private enum Endpoint {
    static let robots: URL = URL(string: "https://acoding.academy/testData/EmpleadosData.json")!
}

enum RobotDataSourceError: Error {
    case networkNotConnected
    case decoding
    case server
    case unknown(Error)
}

final class RobotRemoteDataSource: RobotDataSourceProtocol {

    private let session: URLSessionProtocol

    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }

    func fetch() async throws(RobotDataSourceError) -> [RobotDTO] {
        // Network: Manage URLErrors
        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(from: Endpoint.robots)
        } catch let error as URLError {
            switch error.code {
            case .notConnectedToInternet, .timedOut, .networkConnectionLost:
                Logger.network.error("Network error: \(error.localizedDescription)")
                throw .networkNotConnected
            default:
                Logger.network.error("Unexpected network error: \(error.localizedDescription)")
                throw .unknown(error)
            }
        } catch {
            Logger.unknown.error("Unexpected error fetching robots: \(error.localizedDescription)")
            throw .unknown(error)
        }

        // HTTP response validation
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            Logger.network.error("Server responded with a non-200 status.")
            throw .server
        }

        // Decodification
        do {
            return try JSONDecoder().decode([RobotDTO].self, from: data)
        } catch {
            Logger.decoding.error("Decoding error: \(error.localizedDescription)")
            throw .decoding
        }
    }
}
