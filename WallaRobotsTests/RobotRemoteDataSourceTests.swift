//
//  RobotRemoteDataSourceTests.swift
//  WallaRobotsTests
//

import XCTest
@testable import WallaRobots

@MainActor
final class RobotRemoteDataSourceTests: XCTestCase {

    // MARK: - Tests

    func testFetchReturnsDecodedRobots() async throws {
        // GIVEN: A valid JSON response from the session
        var fakeSession = FakeURLSession()
        fakeSession.mockData = loadMockJSON()
        fakeSession.mockStatusCode = 200
        let dataSource = RobotRemoteDataSource(session: fakeSession)

        // WHEN: We fetch the robots
        let robots = try await dataSource.fetch()

        // THEN: The robots are decoded correctly
        XCTAssertFalse(robots.isEmpty, "Should return robots from valid JSON")
        XCTAssertEqual(robots.first?.username, "heyres0")
        XCTAssertEqual(robots.first?.first_name, "Hadley")
        XCTAssertEqual(robots.first?.last_name, "Eyres")
    }

    func testFetchThrowsOnBadStatusCode() async throws {
        // GIVEN: A 500 server error response
        var fakeSession = FakeURLSession()
        fakeSession.mockStatusCode = 500
        let dataSource = RobotRemoteDataSource(session: fakeSession)

        // WHEN / THEN: Fetch should throw a badServerResponse error
        do {
            _ = try await dataSource.fetch()
            XCTFail("Should have thrown an error")
        } catch let error as URLError {
            XCTAssertEqual(error.code, .badServerResponse)
        }
    }

    func testFetchThrowsOnNetworkError() async throws {
        // GIVEN: A session that throws a network error
        var fakeSession = FakeURLSession()
        fakeSession.shouldThrow = true
        let dataSource = RobotRemoteDataSource(session: fakeSession)

        // WHEN / THEN: Fetch should propagate the network error
        do {
            _ = try await dataSource.fetch()
            XCTFail("Should have thrown an error")
        } catch let error as URLError {
            XCTAssertEqual(error.code, .notConnectedToInternet)
        }
    }

    func testFetchThrowsOnInvalidJSON() async throws {
        // GIVEN: An invalid JSON response
        var fakeSession = FakeURLSession()
        fakeSession.mockData = "invalid json".data(using: .utf8)!
        fakeSession.mockStatusCode = 200
        let dataSource = RobotRemoteDataSource(session: fakeSession)

        // WHEN / THEN: Fetch should throw a decoding error
        do {
            _ = try await dataSource.fetch()
            XCTFail("Should have thrown a decoding error")
        } catch {
            XCTAssertTrue(error is DecodingError, "Should be a DecodingError")
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
