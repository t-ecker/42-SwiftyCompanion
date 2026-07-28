//
//  UserData.swift
//  Swifty-Companion
//
//  Created by Tom Ecker on 27.07.26.
//

import Foundation

nonisolated struct UserData: Codable {
    let login: String
    let email: String
    let pictureLink: String
    let firstName: String
    let lastName: String
    
    let campusCity: String
    
    let start: String
    let level: Double
    let skills: [Skill]
    
    let projects: [Project]
    
    init(from decoder: any Decoder) throws {
        let raw = try rawUserData(from: decoder)
        login = raw.login
        email = raw.email
        pictureLink = raw.image.link
        firstName = raw.firstName
        lastName = raw.lastName
        
        campusCity = raw.campus.first?.city ?? "Unknown"
        
        start = raw.cursus_users.last?.beginAt ?? "Unknown"
        level = raw.cursus_users.last?.level ?? 0
        skills = raw.cursus_users.last?.skills ?? []
        
        projects = raw.project_users.map { Project_user in
            Project(
                finalGrade: Project_user.final_mark,
                projectName: Project_user.project.name,
                projectValidated: Project_user.validated
            )
        }
    }
}

nonisolated struct Skill: Codable {
    let id: Int
    let level: Double
    let name: String
}

nonisolated struct Project: Codable {
    let finalGrade: Int
    let projectName: String
    let projectValidated: Bool
}

nonisolated private struct rawUserData: Decodable {
    let login: String
    let email: String
    let firstName: String
    let lastName: String
    
    let campus: [Campus]
    let image: Image
    let cursus_users: [Curse]
    let project_users: [Project_user]
    
    enum CodingKeys: String, CodingKey {
        case login, email, campus, image, cursus_users, project_users
        case firstName = "first_name"
        case lastName = "last_name"
    }
    
    struct Campus: Decodable {
        let city: String
    }
    struct Image: Decodable {
        let link: String
    }
    struct Curse: Decodable {
        let beginAt: String
        let level: Double
        let skills: [Skill]
        
        enum CodingKeys: String, CodingKey {
            case beginAt = "begin_at"
            case level, skills
        }
    }
    struct Project_user: Decodable {
        let project: projectRaw
        let final_mark: Int
        let validated: Bool
        
        enum CodingKeys: String, CodingKey {
            case project, final_mark
            case validated = "validated?"
        }
    }
    struct projectRaw: Decodable {
        let name: String
    }
}
    

//email
//login
//firstname
//lastname
//picture
//project_users []
//campus.city
//
//for common core not piscine:
//cursus_users: level
//cursus_users: beginAt
//skills: id, level, name
