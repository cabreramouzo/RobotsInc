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

struct Robot: Identifiable, Codable, Hashable {
    let id: Int
    let username: String
    let firstName: String
    let lastName: String
    let gender: Gender
    let email: String
    let department: Department
    let address: String
    let avatar: URL
    
    enum CodingKeys: String, CodingKey {
        case id, username, email, avatar, gender, department, address
        case firstName = "first_name"
        case lastName = "last_name"
    }
    
    var fullName: String { "\(firstName) \(lastName)" }
    
    var price: Double {
        // Random price
        return Double.random(in: Range(uncheckedBounds: (lower: 1.0, upper: 1024.0)))
    }

    var category: RobotCategory {
        department == .humanResources ? .generalServicesRobot : .cleaningRobot
    }
    
    var status: RobotStatus {
        [.new, .refurbished].randomElement() ?? .new
    }
}

