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
    let firstName: String
    let lastName: String
    let gender: String
    let email: String
    let department: String
    let address: String
    let avatar: String?

    enum CodingKeys: String, CodingKey {
        case id, username, gender, email, department, address, avatar
        case firstName = "first_name"
        case lastName = "last_name"
    }
}

// MARK: - Mappers

extension RobotDTO {
    func toDomain() -> Robot {
        Robot(
            id: id,
            username: username,
            firstName: firstName,
            lastName: lastName,
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
