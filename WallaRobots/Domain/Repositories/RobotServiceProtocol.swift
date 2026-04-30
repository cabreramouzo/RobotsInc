//
//  RobotServiceProtocol.swift
//  WallaRobots
//
//  Created by Miguel Cabrera on 27/04/2026.
//


protocol RobotServiceProtocol {
    func fetchRobots() async throws -> [Robot]
}