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
    func testRobotRowSnapshot() {
        // GIVEN: A robot with fixed price and status for deterministic snapshots
        let robot = Robot(
            id: 1,
            username: "r2d2",
            firstName: "R2",
            lastName: "D2",
            gender: .male,
            email: "r2d2@wallapop.com",
            department: .humanResources,
            address: "127.0.0.1",
            avatar: URL(string: "https://robohash.org/r2d2.png")!,
            price: 99.99,
            status: .new
        )

        let viewModel = RobotViewModel(service: FakeRobotService.previewService)

        // WHEN: Create the REAL RobotRow view
        let view = RobotRow(robot: robot)
            .environmentObject(viewModel)
            .frame(width: 390)

        // THEN: Snapshot
        assertSnapshot(of: view, as: .image)
    }
}
