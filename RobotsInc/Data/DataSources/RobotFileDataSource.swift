//
//  RobotFileDataSource.swift
//  RobotsInc
//
//  Created by Miguel Cabrera on 20/07/2026.
//

import Foundation
import OSLog

/// Persists robots as a JSON file in the caches directory. Modeled as an
/// actor so the synchronous file I/O runs off the main actor.
actor RobotFileDataSource: RobotLocalDataSourceProtocol {

    private let fileURL: URL

    init(filename: String = "robots_cache.json") {
        let caches = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        self.fileURL = caches.appendingPathComponent(filename)
    }

    func save(_ robots: [RobotDTO]) async throws {
        let data = try JSONEncoder().encode(robots)
        try data.write(to: fileURL, options: .atomic)
        Logger.storage.info("Cached \(robots.count) robots to disk.")
    }

    func load() async throws -> [RobotDTO] {
        guard FileManager.default.fileExists(atPath: fileURL.path) else { return [] }
        let data = try Data(contentsOf: fileURL)
        return try JSONDecoder().decode([RobotDTO].self, from: data)
    }
}
