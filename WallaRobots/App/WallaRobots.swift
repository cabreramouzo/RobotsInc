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
    
    @State private var robotViewModel = RobotViewModel()
    
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        WindowGroup {
            RobotListView()
                .environment(robotViewModel)
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            if newPhase == .background {
                Logger.viewCycle.info("The App went to background, could save some data here.")
            }
        }
    }
}
