//
//  Logger+Extensions.swift
//  RobotsInc
//
//  Created by Miguel Cabrera on 21/04/2026.
//

import OSLog

extension Logger {
    private static var subsystem = Bundle.main.bundleIdentifier!
    static let viewCycle = Logger(subsystem: subsystem, category: "viewcycle")
    static let network = Logger(subsystem: subsystem, category: "network")
    static let decoding = Logger(subsystem: subsystem, category: "decoding")
    static let unknown = Logger(subsystem: subsystem, category: "unknown")
}
