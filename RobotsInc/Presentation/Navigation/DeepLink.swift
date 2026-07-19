//
//  DeepLink.swift
//  RobotsInc
//
//  Created by Miguel Cabrera on 19/07/2026.
//

import Foundation

/// Parses incoming URLs into navigation intents.
/// Supported: robotsinc://robot/<id>
enum DeepLink {
    nonisolated static func robotID(from url: URL) -> Int? {
        guard url.scheme == "robotsinc",
              url.host() == "robot",
              let id = Int(url.lastPathComponent) else {
            return nil
        }
        return id
    }
}
