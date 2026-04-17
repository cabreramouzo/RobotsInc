//
//  Robot.swift
//  WallaMarvel
//
//  Created by Miguel Cabrera on 16/04/2026.
//
// https://acoding.academy/testData/EmpleadosData.json

import Foundation


let urlRobots = URL(string: "https://acoding.academy/testData/EmpleadosData.json")!


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

struct Robot: Identifiable, Codable, Hashable {
    let id: Int // podria ser UUID?
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
        return Double(id) * 12.9
    }
    
    var category: String {
        department == .humanResources ? "Services" : "Robots"
    }
    
    var status: String {
        let rand = [1,2,3,4,5,6,7,8,9,10].randomElement() ?? 1
        return rand % 2 == 0 ? "New" : "Refurbished"
    }
}

