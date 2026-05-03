//
//  FakeRobotService.swift
//  WallaRobots
//
//  Created by Miguel Cabrera on 19/04/2026.
//

import Foundation

final class FakeRobotDataSource: RobotDataSourceProtocol {
    var result: Result<[RobotDTO], Error> = .success([])
    var fetchCalled = false

    func fetch() async throws -> [RobotDTO] {
        fetchCalled = true
        switch result {
            case .success(let robots):
                return robots
            case .failure(let error):
                throw error
        }
    }

    // Helper to load JSON locally
    static func loadMockDTOs() -> [RobotDTO] {
        guard let json = Bundle(for: Self.self).url(forResource: "test_robots", withExtension: "json"),
              let jsonData = try? Data(contentsOf: json) else {
            return []
        }

        let decoder = JSONDecoder()
        return (try? decoder.decode([RobotDTO].self, from: jsonData)) ?? []
    }
}

extension FakeRobotDataSource {
    static var previewDataSource: FakeRobotDataSource {
        let dataSource = FakeRobotDataSource()
        dataSource.result = .success(loadMockDTOs())
        return dataSource
    }

    static var error: FakeRobotDataSource {
        let dataSource = FakeRobotDataSource()
        dataSource.result = .failure(URLError(.notConnectedToInternet))
        return dataSource
    }
}
