//
//  RobotListView.swift
//  WallaMarvel
//
//  Created by Miguel Cabrera on 17/04/2026.
//

import SwiftUI

struct RobotListView: View {
    @StateObject var viewModel = RobotViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    ForEach(viewModel.filteredRobots, id: \.id) { robot in
                        RobotRow(robot: robot)
                            .environmentObject(viewModel)
                    }
                }
                .navigationTitle("WallaRobots")
                .task {
                    await viewModel.initialLoad()
                }
                if viewModel.showNetworkError && viewModel.filteredRobots.isEmpty {
                    NetworkErrorView {
                        await viewModel.initialLoad()
                    }
                }
            }
        }
        .searchable(text: $viewModel.searchText, prompt: "Search robots by name or email")
    }
}


// MARK: - Previews

#Preview("List with data") {
    RobotListView(viewModel: RobotViewModel(service: FakeRobotService.previewService))
}

#Preview("Network error state") {
    RobotListView(viewModel: RobotViewModel(service: FakeRobotService.error))
}

