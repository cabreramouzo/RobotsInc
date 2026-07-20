//
//  Logger+Extensions.swift
//  RobotsInc
//
//  Created by Miguel Cabrera on 21/04/2026.
//

import OSLog

extension Logger {
    nonisolated private static let subsystem = Bundle.main.bundleIdentifier!
    nonisolated static let viewCycle = Logger(subsystem: subsystem, category: "viewcycle")
    nonisolated static let network = Logger(subsystem: subsystem, category: "network")
    nonisolated static let decoding = Logger(subsystem: subsystem, category: "decoding")
    nonisolated static let unknown = Logger(subsystem: subsystem, category: "unknown")
    nonisolated static let storage = Logger(subsystem: subsystem, category: "storage")
}
