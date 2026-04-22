//
//  Robot.swift
//  WallaMarvel
//
//  Created by Miguel Cabrera on 16/04/2026.
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

struct Robot: Identifiable, Hashable, Decodable {
    let id: Int
    let username: String
    let firstName: String
    let lastName: String
    let gender: Gender
    let email: String
    let department: Department
    let address: String
    let avatar: URL?

    // Stored properties with default random values (not in JSON)
    let price: Double
    let status: RobotStatus

    enum CodingKeys: String, CodingKey {
        case id, username, email, avatar, gender, department, address
        case firstName = "first_name"
        case lastName = "last_name"
    }

    var fullName: String { "\(firstName) \(lastName)" }

    var category: RobotCategory {
        department == .humanResources ? .generalServicesRobot : .cleaningRobot
    }

    // Deterministic initializer for testing and preview purposes
    init(id: Int, username: String, firstName: String, lastName: String, gender: Gender, email: String, department: Department, address: String, avatar: URL? = nil, price: Double = Double.random(in: 1.0...1024.0), status: RobotStatus = [.new, .refurbished].randomElement() ?? .new) {
        self.id = id
        self.username = username
        self.firstName = firstName
        self.lastName = lastName
        self.gender = gender
        self.email = email
        self.department = department
        self.address = address
        self.avatar = avatar
        self.price = price
        self.status = status
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // Decode all JSON properties
        id = try container.decode(Int.self, forKey: .id)
        username = try container.decode(String.self, forKey: .username)
        firstName = try container.decode(String.self, forKey: .firstName)
        lastName = try container.decode(String.self, forKey: .lastName)
        gender = try container.decode(Gender.self, forKey: .gender)
        email = try container.decode(String.self, forKey: .email)
        department = try container.decode(Department.self, forKey: .department)
        address = try container.decode(String.self, forKey: .address)
        avatar = try container.decodeIfPresent(URL.self, forKey: .avatar)

        // Generate random values for non-JSON properties
        price = Double.random(in: 1.0...1024.0)
        status = [.new, .refurbished].randomElement() ?? .new
    }
}

