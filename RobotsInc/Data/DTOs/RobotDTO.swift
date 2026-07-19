//
//  RobotDTO.swift
//  RobotsInc
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
            price: Decimal(Int.random(in: 100...102_400)) / 100,
            status: [.new, .refurbished].randomElement() ?? .new
        )
    }
}
