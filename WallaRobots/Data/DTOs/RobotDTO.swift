//
//  RobotDTO.swift
//  WallaRobots
//
//  Created by Miguel Cabrera on 01/05/2026.
//

import Foundation

enum Department: String, Codable {
    case accounting = "Accounting"
    case businessDevelopment = "Business Development"
    case engineering = "Engineering"
    case humanResources = "Human Resources"
    case legal = "Legal"
    case marketing = "Marketing"
    case productManagement = "Product Management"
    case researchAndDevelopment = "Research and Development"
    case sales = "Sales"
    case services = "Services"
    case support = "Support"
    case training = "Training"
}

enum Gender: String, Codable {
    case female = "Female"
    case male = "Male"
}

enum RobotCategory: String {
    case generalServicesRobot = "General Robots"
    case cleaningRobot = "Cleaning Robots"
}

enum RobotStatus: String {
    case new = "New"
    case refurbished = "Refurbished"
}

enum CodingKeys: String, CodingKey {
    case id, username, email, avatar, gender, department, address
    case firstName = "first_name"
    case lastName = "last_name"
}

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
