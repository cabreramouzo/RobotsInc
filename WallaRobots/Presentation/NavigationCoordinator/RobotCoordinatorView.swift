//
//  RobotCoordinatorView.swift
//  WallaRobots
//
//  Created by Miguel Cabrera on 01/05/2026.
//

import SwiftUI

struct RobotCoordinatorView: View {
    @State private var coordinator = RobotCoordinator()
    @State private var viewModel: RobotViewModel

    let repository: RobotRepositoryProtocol

    init(repository: RobotRepositoryProtocol) {
        self.repository = repository
        self._viewModel = State(wrappedValue: RobotViewModel(repository: repository))
    }

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            RobotListView(viewModel: viewModel, onSelectRobot: { robot in
                coordinator.showDetail(for: robot)
            })
            .navigationDestination(for: Destination.self) { destination in
                switch destination {
                    case .detail(let robot):
                        RobotDetailView(robot: robot)
                }
            }
        }
    }
}
