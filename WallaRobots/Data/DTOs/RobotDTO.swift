//
//  RobotDTO.swift
//  WallaRobots
//
//  Created by Miguel Cabrera on 01/05/2026.
//

import Foundation

struct RobotDTO: Decodable {
    let id: Int
    let username: String
    let first_name: String
    let last_name: String
    let gender: String
    let email: String
    let department: String
    let address: String
    let avatar: String?
}

// MARK: - Mappers

extension RobotDTO {
    func toDomain() -> Robot {
        Robot(
            id: id,
            username: username,
            firstName: first_name,
            lastName: last_name,
            gender: Gender(rawValue: gender) ?? .male,
            email: email,
            department: Department(rawValue: department) ?? .engineering,
            address: address,
            avatar: URL(string: avatar ?? ""),
            price: Double.random(in: 1.0...1024.0),
            status: [.new, .refurbished].randomElement() ?? .new
        )
    }
}
