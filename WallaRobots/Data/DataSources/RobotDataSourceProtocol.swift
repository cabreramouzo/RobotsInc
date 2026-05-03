//
//  RobotDataSourceProtocol.swift
//  WallaRobots
//
//  Created by Miguel Cabrera on 27/04/2026.
//


protocol RobotDataSourceProtocol: Sendable {
    func fetch() async throws -> [RobotDTO]
}
