//
//  UserData.swift
//  Swifty-Companion
//
//  Created by Tom Ecker on 27.07.26.
//

import Foundation

nonisolated struct UserData: Codable, Identifiable, Hashable {
    let id: String
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
        id = raw.login
        email = raw.email
        pictureLink = raw.image.link
        firstName = raw.firstName
        lastName = raw.lastName
        
        campusCity = raw.campus.first?.city ?? "Unknown"
        
        start = raw.cursusUsers.last?.beginAt ?? "Unknown"
        level = raw.cursusUsers.last?.level ?? 0
        skills = raw.cursusUsers.last?.skills ?? []
        
        projects = raw.projectUsers.map { ProjectUser in
            Project(
                finalGrade: ProjectUser.final_mark,
                projectName: ProjectUser.project.name,
                projectValidated: ProjectUser.validated
            )
        }
    }
}

nonisolated struct Skill: Codable, Hashable {
    let id: Int
    let level: Double
    let name: String
}

nonisolated struct Project: Codable, Hashable {
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
    let cursusUsers: [Curse]
    let projectUsers: [ProjectUser]
    
    enum CodingKeys: String, CodingKey {
        case login, email, campus, image
        case firstName = "first_name"
        case lastName = "last_name"
        case cursusUsers = "cursus_users"
        case projectUsers = "project_users"
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
    struct ProjectUser: Decodable {
        let project: projectInfo
        let final_mark: Int
        let validated: Bool
        
        enum CodingKeys: String, CodingKey {
            case project, final_mark
            case validated = "validated?"
        }
    }
    struct projectInfo: Decodable {
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
