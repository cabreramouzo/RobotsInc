//
//  RobotListView.swift
//  WallaMarvel
//
//  Created by Miguel Cabrera on 17/04/2026.
//

import SwiftUI
import Kingfisher

struct RobotListView: View {
    @StateObject var viewModel = RobotViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    ForEach(viewModel.filteredRobots, id: \.id) { robot in
                        NavigationLink {
                            robotDetailView(robot: robot)
                        } label: {
                            HStack {
                                robotAvatarImage(robot: robot)
                                robotVerticalStack(robot: robot)

                                Spacer()

                                Text(robot.status)
                                    .font(.caption)
                                    .padding(6)
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(4)
                            }
                            .accessibilityElement(children: .combine)
                            .accessibilityHint("Double tap to view details of \(robot.fullName)")
                            .onAppear {
                                if viewModel.searchText.isEmpty && robot.id == viewModel.filteredRobots.last?.id {
                                    Task {
                                        try? await viewModel.loadMoreRobots()
                                    }
                                }
                            }
                        }
                        .id(robot.id)
                        .accessibilityIdentifier("RobotRow_\(robot.id)")
                    }
                }
                .navigationTitle("WallaRobots")
                .task {
                    try? await viewModel.initialLoad()
                }
                if viewModel.showNetworkError && viewModel.filteredRobots.isEmpty {
                    NetworkErrorView {
                        try? await viewModel.initialLoad()
                    }
                }
            }
        }
        .searchable(text: $viewModel.searchText, prompt: "Search robots by name or email")
    }
}

// MARK: Subviews

@ViewBuilder
func robotVerticalStack(robot: Robot) -> some View {
    VStack(alignment: .leading) {
        Text(robot.fullName).font(.headline)
        Text(robot.email).font(.subheadline).foregroundColor(.gray)
        Text("\(robot.price, specifier: "%.2f")€")
            .font(.system(size: 18, weight: .bold))
            .foregroundColor(Color(red: 0.07, green: 0.76, blue: 0.67))
    }
}

@ViewBuilder
func robotAvatarImage(robot: Robot) -> some View {
    KFImage(robot.avatar)
        .placeholder {
            RobotAvatarPlaceholder()
        }
        .retry(maxCount: 3, interval: .seconds(1))
        .onSuccess { result in
        }
        .onFailure { error in
            print("Error leading avatar image: \(error)")
        }
        .resizable()
        .scaledToFill()
        .frame(width: 50, height: 50)
        .clipShape(Circle())
        .accessibilityLabel("Avatar of \(robot.fullName)")
        .id(robot.id)
}

@ViewBuilder
func RobotAvatarPlaceholder() -> some View {
    ZStack {
        Color.gray.opacity(0.1)
        Image(systemName: "person.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 20, height: 20)
    }
}


// MARK: Previews

#Preview("List with data") {
    RobotListView(viewModel: RobotViewModel(service: FakeRobotService.previewService))
}

#Preview("Network error state") {
    RobotListView(viewModel: RobotViewModel(service: FakeRobotService.error))
}

