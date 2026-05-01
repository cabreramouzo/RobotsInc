//
//  RobotCoordinator.swift
//  WallaRobots
//
//  Created by Miguel Cabrera on 01/05/2026.
//

import SwiftUI

@Observable
final class RobotCoordinator {

    var path = NavigationPath()

    func showDetail(for robot: Robot) {
        path.append(Destination.detail(robot: robot))
    }

    func popToRoot() {
        path.removeLast(path.count)
    }
}
