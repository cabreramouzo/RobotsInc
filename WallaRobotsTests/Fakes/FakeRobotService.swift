//
//  FakeRobotService.swift
//  WallaRobots
//
//  Created by Miguel Cabrera on 19/04/2026.
//


import Foundation
@testable import WallaRobots

final class FakeRobotService: RobotServiceProtocol {
    var result: Result<[Robot], Error> = .success([])
    var fetchCalled = false

    func fetchRobots() async throws -> [Robot] {
        fetchCalled = true
        switch result {
        case .success(let robots):
            return robots
        case .failure(let error):
            throw error
        }
    }
    
    // Helper to load JSON locally
    static func loadMockRobots() -> [Robot] {
        let json = Bundle(for: Self.self).url(forResource: "test_robots", withExtension: "json")!
        let jsonData = try! Data(contentsOf: json)
        
        let decoder = JSONDecoder()
        return (try? decoder.decode([Robot].self, from: jsonData)) ?? []
    }
}

extension FakeRobotService {
    static var previewService: FakeRobotService {
        let service = FakeRobotService()
        service.result = .success(loadMockRobots())
        return service
    }

    static var error: FakeRobotService {
        let service = FakeRobotService()
        service.result = .failure(URLError(.notConnectedToInternet))
        return service
    }
}
