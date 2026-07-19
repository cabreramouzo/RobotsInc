//
//  RobotRepositoryProtocol.swift
//  RobotsInc
//
//  Created by Miguel Cabrera on 01/05/2026.
//

protocol RobotRepositoryProtocol {
    func fetch() async throws(RobotRepositoryError) -> [Robot]
    func robot(withID id: Int) async throws(RobotRepositoryError) -> Robot
}
