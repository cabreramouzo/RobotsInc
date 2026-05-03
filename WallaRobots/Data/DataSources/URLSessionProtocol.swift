//
//  URLSessionProtocol.swift
//  WallaRobots
//
//  Created by Miguel Cabrera on 03/05/2026.
//

import Foundation

protocol URLSessionProtocol {
    func data(from url: URL) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}
