//
//  Logger+Extensions.swift
//  WallaRobots
//
//  Created by Miguel Cabrera on 21/04/2026.
//

import OSLog

extension Logger {
    private static var subsystem = Bundle.main.bundleIdentifier!
    static let viewCycle = Logger(subsystem: subsystem, category: "viewcycle")
    static let network = Logger(subsystem: subsystem, category: "network")
}
