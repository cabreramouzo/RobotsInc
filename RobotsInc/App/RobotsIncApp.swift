//
//  RobotsInc.swift
//  RobotsInc
//
//  Created by Miguel Cabrera on 17/04/2026.
//

import SwiftUI
import OSLog

@main
struct RobotsInc: App {

    @Environment(\.scenePhase) private var scenePhase

    /// This config is to show timeout error in less than 10 seconds
    /// for demostration porpuses only
    func defaultSessionConfiguration() -> URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 10
        return configuration
    }

    var body: some Scene {
        WindowGroup {
            let session = URLSession(configuration: defaultSessionConfiguration())
            let repository = RobotRepository(dataSource: RobotRemoteDataSource(session: session))

            AppCoordinatorView(repository: repository)

        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            if newPhase == .background {
                Logger.viewCycle.info("The App went to background, could save some data here.")
            }
        }
    }
}
