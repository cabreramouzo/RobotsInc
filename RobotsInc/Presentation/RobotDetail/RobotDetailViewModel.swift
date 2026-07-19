//
//  RobotDetailViewModel.swift
//  RobotsInc
//
//  Created by Miguel Cabrera on 19/07/2026.
//

import SwiftUI

@Observable
final class RobotDetailViewModel {

    private(set) var robot: Robot?
    private(set) var error: RobotRepositoryError?

    private let robotID: Int
    private let repository: RobotRepositoryProtocol

    init(robotID: Int, repository: RobotRepositoryProtocol) {
        self.robotID = robotID
        self.repository = repository
    }

    var errorViewData: ErrorViewData? {
        error?.viewData
    }

    @MainActor
    func load() async {
        do {
            robot = try await repository.robot(withID: robotID)
            error = nil
        } catch {
            self.error = error
        }
    }
}
