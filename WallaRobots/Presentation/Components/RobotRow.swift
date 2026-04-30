//
//  RobotRow.swift
//  WallaRobots
//
//  Created by Miguel Cabrera on 20/04/2026.
//

import SwiftUI
import Kingfisher
import OSLog

struct RobotRow: View {
    let robot: Robot
    @Environment(RobotViewModel.self) var viewModel

    var body: some View {
        NavigationLink {
            RobotDetailView(robot: robot)
        } label: {
            HStack {
                robotAvatarImage(robot: robot)
                robotVerticalStack(robot: robot)

                Spacer()

                Text(robot.status.rawValue)
                    .font(.caption)
                    .padding(6)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(4)
            }
            .accessibilityElement(children: .combine)
            .accessibilityHint("Double tap to view details of \(robot.fullName)")
            .onAppear {
                if viewModel.searchText.isEmpty && robot.id == viewModel.filteredRobots.last?.id {
                    viewModel.loadMoreRobots()
                }
            }
        }
        .id(robot.id)
        .accessibilityIdentifier("RobotRow_\(robot.id)")
    }
}

// MARK: - Subviews
private extension RobotRow {

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
        if let avatarURL = robot.avatar {
            KFImage(avatarURL)
                .placeholder {
                    robotAvatarPlaceholder()
                }
                .retry(maxCount: 3, interval: .seconds(1))
                .onSuccess { result in
                }
                .onFailure { error in
                    Logger.network.error("Error loading avatar image: \(error)")
                }
                .resizable()
                .scaledToFill()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                .accessibilityLabel("Avatar of \(robot.fullName)")
                .id(robot.id)
        } else {
            robotAvatarPlaceholder()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                .accessibilityLabel("Avatar of \(robot.fullName)")
        }
    }

    @ViewBuilder
    func robotAvatarPlaceholder() -> some View {
        ZStack {
            Color.gray.opacity(0.1)
            Image(systemName: "person.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
        }
    }
}

#Preview {
    let r2d2 = Robot(
        id: 1,
        username: "r2d2",
        firstName: "R2",
        lastName: "D2",
        gender: .male,
        email: "r2d2@wallapop.com",
        department: .humanResources,
        address: "127.0.0.1",
        avatar: URL(string: "https://robohash.org/r2d2.png")!
    )
    RobotRow(robot: r2d2)
        .environment(RobotViewModel(service: FakeRobotService.previewService))
}

