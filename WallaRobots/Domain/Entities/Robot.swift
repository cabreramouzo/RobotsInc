//
//  Robot.swift
//  WallaRobots
//
//  Created by Miguel Cabrera on 01/05/2026.
//

import Foundation

struct Robot: Identifiable, Hashable {
    let id: Int
    let username: String
    let firstName: String
    let lastName: String
    let gender: Gender
    let email: String
    let department: Department
    let address: String
    let avatar: URL?
    let price: Double
    let status: RobotStatus

    var fullName: String { "\(firstName) \(lastName)" }
}
