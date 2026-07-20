//
//  RobotDTO.swift
//  RobotsInc
//
//  Created by Miguel Cabrera on 01/05/2026.
//

import Foundation

struct RobotDTO: Codable {
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
            // The dataset has no price, no status, so we generate them
            price: Decimal(id % 1000) + 0.99,
            status: id.isMultiple(of: 2) ? .new : .refurbished
        )
    }
}
