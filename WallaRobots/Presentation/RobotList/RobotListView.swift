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
            List {
                ForEach(viewModel.filteredRobots, id: \.id) { robot in
                    NavigationLink {
                        RobotDetailView(robot: robot)
                    } label: {
                        HStack {
                            AsyncImage(url: robot.avatar) { image in
                                image.resizable()
                            } placeholder: {
                                Color.gray.opacity(0.1)
                            }
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                            .id(robot.id)

                            VStack(alignment: .leading) {
                                Text(robot.fullName).font(.headline)
                                Text(robot.email).font(.subheadline).foregroundColor(.gray)
                                Text("\(robot.price, specifier: "%.2f")€")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(Color(red: 0.07, green: 0.76, blue: 0.67))
                            }
                            Spacer()

                            Text(robot.status)
                                .font(.caption)
                                .padding(6)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(4)
                        }
                        .onAppear {
                            if viewModel.searchText.isEmpty && robot.id == viewModel.filteredRobots.last?.id {
                                Task {
                                    try? await viewModel.loadMoreRobots()
                                }
                            }
                        }
                    }
                    .id(robot.id)
                }
            }
            .navigationTitle("WallaRobots")
            .task {
                try? await viewModel.initialLoad()
            }
        }
        .searchable(text: $viewModel.searchText, prompt: "Search robots by name or email")
    }
}

