//
//  SnapshotTests.swift
//  WallaRobots
//
//  Created by Miguel Cabrera on 22/04/2026.
//

@testable import WallaRobots
import SnapshotTesting
import SwiftUI
import XCTest

final class SnapshotTests: XCTestCase {

    @MainActor
    func testRobotRowSnapshot() throws {

        // GIVEN: A robot with fixed values and no avatar (shows placeholder)
        let robot = Robot(
            id: 1,
            username: "r2d2",
            firstName: "R2",
            lastName: "D2",
            gender: .male,
            email: "r2d2@wallapop.com",
            department: .humanResources,
            address: "127.0.0.1",
            // avatar: nil (default) - shows placeholder
            price: 99.99,
            status: .new
        )

        let viewModel = RobotViewModel(service: FakeRobotService.previewService)

        // WHEN: Create the REAL RobotRow view
        let view = RobotRow(robot: robot)
            .environmentObject(viewModel)
            .frame(width: 390)

        // THEN: Snapshot
        assertSnapshot(of: view, as: .image(precision: 0.95))
    }

    @MainActor
    func testRobotDetailViewSnapshot() throws {

        // GIVEN: A robot with fixed values and no avatar (shows placeholder)
        let robot = Robot(
            id: 1,
            username: "r2d2",
            firstName: "R2",
            lastName: "D2",
            gender: .male,
            email: "r2d2@wallapop.com",
            department: .humanResources,
            address: "127.0.0.1",
            // avatar: nil (default) - shows placeholder
            price: 599.99,
            status: .refurbished
        )

        // WHEN: Create the RobotDetailView
        let view = NavigationStack {
            RobotDetailView(robot: robot)
        }

        // THEN: Snapshot
        assertSnapshot(of: view, as: .image(precision: 0.95))
    }
}
