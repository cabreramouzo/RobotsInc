//
//  RobotCoordinatorView.swift
//  RobotsInc
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
                coordinator.showDetail(robotID: robot.id)
            })
            .navigationDestination(for: Destination.self) { destination in
                switch destination {
                    case .detail(let robotID):
                        RobotDetailView(
                            viewModel: RobotDetailViewModel(robotID: robotID, repository: repository)
                        )
                }
            }
        }
        // Deep links reuse the exact same navigation route as a tap on the
        // list: one route, two origins.
        .onOpenURL { url in
            if let robotID = DeepLink.robotID(from: url) {
                coordinator.showDetail(robotID: robotID)
            }
        }
    }
}
