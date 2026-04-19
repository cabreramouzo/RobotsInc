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
    
    // Helper para cargar el JSON local
    static func loadMockRobots() -> [Robot] {
        let json = Bundle(for: Self.self).url(forResource: "test_robots", withExtension: "json")!
        let jsonData = try! Data(contentsOf: json)
        
        let decoder = JSONDecoder()
        // No olvides configurar el keyDecodingStrategy si el JSON real es snake_case
        return (try? decoder.decode([Robot].self, from: jsonData)) ?? []
    }
}
