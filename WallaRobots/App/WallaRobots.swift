//
//  WallaRobots.swift
//  WallaMarvel
//
//  Created by Miguel Cabrera on 17/04/2026.
//

import SwiftUI

@main
struct WallaRobots: App {

    @StateObject private var robotViewModel = RobotViewModel()

    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            RobotListView()
                .environmentObject(robotViewModel)
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            if newPhase == .background {
                print("The App went to background, could save some data here.")
            }
        }
    }
}
