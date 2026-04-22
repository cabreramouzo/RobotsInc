//
//  RobotDetailView.swift
//  WallaRobots
//
//  Created by Miguel Cabrera on 18/04/2026.
//
import SwiftUI

struct RobotDetailView: View {
    let robot: Robot

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                avatarView
                    .frame(width: 200, height: 200)
                    .padding(.top, 20)
                    .accessibilityLabel("Avatar of \(robot.fullName)")

                VStack(alignment: .leading, spacing: 12) {
                    Group {
                        detailRow(label: "Full Name", value: robot.fullName, icon: "person.fill")
                            .accessibilityIdentifier("RobotDetailName")
                        detailRow(label: "Email", value: robot.email, icon: "envelope.fill")
                        detailRow(label: "Department", value: robot.department.rawValue, icon: "briefcase.fill")
                        detailRow(label: "Address", value: robot.address, icon: "mappin.and.ellipse")
                    }

                    Divider().padding(.vertical, 10)

                    HStack {
                        VStack(alignment: .leading) {
                            Text("Estimated price")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Text("\(robot.price, specifier: "%.2f")€")
                                .font(.title2)
                                .bold()
                                .foregroundColor(Color.wallapopColor)
                        }
                        Spacer()
                        Text(robot.status.rawValue)
                            .font(.caption)
                            .bold()
                            .padding(8)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                            .accessibilityValue(robot.status == .new ? "Robot is new" : "Robot is Refurbished")
                    }
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle(robot.username)
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    private var avatarView: some View {
        if let avatarURL = robot.avatar {
            AsyncImage(url: avatarURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.gray.opacity(0.2), lineWidth: 4))
            } placeholder: {
                ProgressView()
            }
        } else {
            // Placeholder for tests/snapshots
            ZStack {
                Circle()
                    .fill(Color.gray.opacity(0.2))
                Image(systemName: "person.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.gray)
            }
            .overlay(Circle().stroke(Color.gray.opacity(0.2), lineWidth: 4))
        }
    }

    @ViewBuilder
    private func detailRow(label: String, value: String, icon: String) -> some View {
        HStack(alignment: .top) {
            Image(systemName: icon)
                .foregroundColor(.secondary)
                .frame(width: 24)
            VStack(alignment: .leading) {
                Text(label).font(.caption).foregroundColor(.secondary)
                Text(value).font(.body)
            }
        }
    }
}

#Preview {
    let testRobot = Robot(id: 2, username: "refurbu",
                          firstName: "Kaniko",
                          lastName: "Lastno",
                          gender: .male,
                          email: "kaniko@gmail.com",
                          department: .humanResources,
                          address: "127.0.0.1",
                          avatar: URL(string: "https://robohash.org/2.png?set=set1&size=180x180"))
    RobotDetailView(robot: testRobot)
}
