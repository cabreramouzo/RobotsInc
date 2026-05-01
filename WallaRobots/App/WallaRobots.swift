//
//  WallaRobots.swift
//  WallaMarvel
//
//  Created by Miguel Cabrera on 17/04/2026.
//

import SwiftUI
import OSLog

@main
struct WallaRobots: App {

    @Environment(\.scenePhase) private var scenePhase

    private let repository: RobotRepositoryProtocol = RobotRepository(dataSource: RobotRemoteDataSource())

    var body: some Scene {
        WindowGroup {
            RobotCoordinatorView(repository: repository)
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            if newPhase == .background {
                Logger.viewCycle.info("The App went to background, could save some data here.")
            }
        }
    }
}

