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
    var viewModel: RobotViewModel
    var onSelectRobot: (Robot) -> Void

    var body: some View {
        @Bindable var viewModel = viewModel
        ZStack {
            List {
                ForEach(viewModel.filteredRobots, id: \.id) { robot in
                    Button {
                        onSelectRobot(robot)
                    } label: {
                        RobotRow(robot: robot)
                            .foregroundStyle(.primary)
                    }
                    .buttonStyle(HighlightButtonStyle())
                    .onAppear {
                        if viewModel.searchText.isEmpty && robot.id == viewModel.filteredRobots.last?.id {
                            viewModel.loadMoreRobots()
                        }
                    }
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
            .searchable(text: $viewModel.searchText, prompt: "Search robots by name or email")

            if viewModel.showNetworkError && viewModel.filteredRobots.isEmpty {
                NetworkErrorView {
                    await viewModel.initialLoad()
                }
            }
        }

    }
}

// MARK: - Previews

#Preview("List with data") {
    NavigationStack {
        RobotListView(
            viewModel: RobotViewModel(repository: RobotRepository(dataSource: FakeRobotDataSource.previewDataSource)),
            onSelectRobot: { _ in }
        )
    }
}

#Preview("Network error state") {
    NavigationStack {
        RobotListView(
            viewModel: RobotViewModel(repository: RobotRepository(dataSource: FakeRobotDataSource.error)),
            onSelectRobot: { _ in }
        )
    }
}
