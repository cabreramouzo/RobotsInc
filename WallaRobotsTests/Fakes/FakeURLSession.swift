//
//  FakeURLSession.swift
//  WallaRobotsTests
//
//  Created by Miguel Cabrera on 03/05/2026.
//

import Foundation
@testable import WallaRobots

struct FakeURLSession: URLSessionProtocol {
    var mockData: Data = Data()
    var mockStatusCode: Int = 200
    var shouldThrow: Bool = false

    func data(from url: URL) async throws -> (Data, URLResponse) {
        if shouldThrow {
            throw URLError(.notConnectedToInternet)
        }

        let response = HTTPURLResponse(
            url: url,
            statusCode: mockStatusCode,
            httpVersion: nil,
            headerFields: nil
        )!

        return (mockData, response)
    }
}
