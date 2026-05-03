//
//  RobotRemoteDataSourceTests.swift
//  WallaRobotsTests
//
//  Created by Miguel Cabrera on 03/05/2026.
//

import Testing
import Foundation
@testable import WallaRobots

struct RobotRemoteDataSourceTests {
    
    // MARK: - Properties
    
    private let fakeSession: FakeURLSession
    private let dataSource: RobotRemoteDataSource
    
    // MARK: - Setup
    
    init() {
        fakeSession = FakeURLSession()
        dataSource = RobotRemoteDataSource(session: fakeSession)
    }
    
    // MARK: - Tests
    
    @Test("Fetch returns decoded robots from valid JSON")
    func testFetchReturnsDecodedRobots() async throws {
        // GIVEN: A valid JSON response from the session
        var session = fakeSession
        session.mockData = loadMockJSON()
        session.mockStatusCode = 200
        let dataSource = RobotRemoteDataSource(session: session)
        
        // WHEN: We fetch the robots
        let robots = try await dataSource.fetch()
        
        // THEN: The robots are decoded correctly
        #expect(!robots.isEmpty, "Should return robots from valid JSON")
        #expect(robots.first?.username == "heyres0")
        #expect(robots.first?.first_name == "Hadley")
        #expect(robots.first?.last_name == "Eyres")
    }
    
    @Test("Fetch throws on bad HTTP status code")
    func testFetchThrowsOnBadStatusCode() async throws {
        // GIVEN: A 500 server error response
        var session = fakeSession
        session.mockStatusCode = 500
        let dataSource = RobotRemoteDataSource(session: session)
        
        // WHEN / THEN: Fetch should throw a badServerResponse error
        await #expect(throws: URLError(.badServerResponse)) {
            try await dataSource.fetch()
        }
    }
    
    @Test("Fetch throws on network error")
    func testFetchThrowsOnNetworkError() async throws {
        // GIVEN: A session that throws a network error
        var session = fakeSession
        session.shouldThrow = true
        let dataSource = RobotRemoteDataSource(session: session)
        
        // WHEN / THEN: Fetch should propagate the network error
        await #expect(throws: URLError(.notConnectedToInternet)) {
            try await dataSource.fetch()
        }
    }
    
    @Test("Fetch throws DecodingError on invalid JSON")
    func testFetchThrowsOnInvalidJSON() async throws {
        // GIVEN: An invalid JSON response
        var session = fakeSession
        session.mockData = "invalid json".data(using: .utf8)!
        session.mockStatusCode = 200
        let dataSource = RobotRemoteDataSource(session: session)
        
        // WHEN / THEN: Fetch should throw a decoding error
        await #expect(throws: (any Error).self) {
            try await dataSource.fetch()
        }
    }
    
    // MARK: - Helpers
    
    private func loadMockJSON() -> Data {
        guard let url = Bundle(for: FakeRobotDataSource.self).url(forResource: "test_robots", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            return Data()
        }
        return data
    }
}
