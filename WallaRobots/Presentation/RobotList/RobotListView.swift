//
//  RobotListView.swift
//  WallaMarvel
//
//  Created by Miguel Cabrera on 17/04/2026.
//

import SwiftUI

private enum Constants {
    static let searchDebounceInterval: Duration = .milliseconds(300)
}

struct RobotListView: View {
    @Environment(RobotViewModel.self) var viewModel

    var body: some View {
        @Bindable var viewModel = viewModel
        NavigationStack {
            ZStack {
                List {
                    ForEach(viewModel.filteredRobots, id: \.id) { robot in
                        RobotRow(robot: robot)
                            .environment(viewModel)
                    }
                }
                .navigationTitle("WallaRobots")
                .task {
                    await viewModel.initialLoad()
                }
                .task(id: viewModel.searchText) {
                    try? await Task.sleep(for: Constants.searchDebounceInterval)
                    viewModel.debouncedSearchText = viewModel.searchText
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
    RobotListView()
        .environment(RobotViewModel(service: FakeRobotService.previewService))
}

#Preview("Network error state") {
    RobotListView()
        .environment(RobotViewModel(service: FakeRobotService.error))
}
