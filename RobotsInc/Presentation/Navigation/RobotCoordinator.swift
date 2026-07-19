//
//  RobotCoordinator.swift
//  RobotsInc
//
//  Created by Miguel Cabrera on 01/05/2026.
//

import SwiftUI

@Observable
final class RobotCoordinator {

    var path = NavigationPath()

    func showDetail(robotID: Int) {
        path.append(Destination.detail(robotID: robotID))
    }

    func popToRoot() {
        path.removeLast(path.count)
    }
}
