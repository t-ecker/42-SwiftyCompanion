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
    let pictureLink: String?
    let firstName: String
    let lastName: String
    let evalPoints: Int
    let grade: String
    let staff: Bool
    
    let campusCity: String
    
    let start: String
    let level: Double
    let skills: [Skill]
    
    let projects: [Project]
    
    init(from decoder: any Decoder) throws {
        let raw = try RawUserData(from: decoder)
        login = raw.login
        id = raw.login
        email = raw.email
        pictureLink = raw.image?.link ?? nil
        firstName = raw.firstName
        lastName = raw.lastName
        evalPoints = raw.evalPoints
        staff = raw.staff
        
        campusCity = raw.campus.first?.city ?? "Unknown"
        
        let commonCore = raw.cursusUsers.first(where: { $0.cursus.name == "42cursus" }) ?? raw.cursusUsers.last
        
        start = commonCore?.beginAt ?? "Unknown"
        level = commonCore?.level ?? 0
        skills = commonCore?.skills ?? []
        grade = commonCore?.grade ?? (staff ? "Staff" : "Unknown")
        
        projects = raw.projectUsers.map { projectUser in
            Project(
                id: projectUser.project.name,
                finalGrade: projectUser.finalMark,
                name: projectUser.project.name,
                isValidated: projectUser.validated
            )
        }
    }
    
    init(
        id: String,
        login: String,
        email: String,
        pictureLink: String?,
        firstName: String,
        lastName: String,
        campusCity: String,
        evalPoints: Int,
        grade: String,
        staff: Bool = false,
        start: String,
        level: Double,
        skills: [Skill],
        projects: [Project]
    ) {
        self.id = id
        self.login = login
        self.email = email
        self.pictureLink = pictureLink
        self.firstName = firstName
        self.lastName = lastName
        self.campusCity = campusCity
        self.evalPoints = evalPoints
        self.grade = grade
        self.staff = staff
        self.start = start
        self.level = level
        self.skills = skills
        self.projects = projects
    }
}

nonisolated struct Skill: Codable, Hashable, Identifiable {
    let id: Int
    let level: Double
    let name: String
}

nonisolated struct Project: Codable, Hashable, Identifiable {
    let id: String
    let finalGrade: Int?
    let name: String
    let isValidated: Bool?
}

nonisolated private struct RawUserData: Decodable {
    let login: String
    let email: String
    let firstName: String
    let lastName: String
    let evalPoints: Int
    let staff: Bool
    
    let campus: [Campus]
    let image: Image?
    let cursusUsers: [Cursus]
    let projectUsers: [ProjectUser]
    
    enum CodingKeys: String, CodingKey {
        case login, email, campus, image
        case firstName = "first_name"
        case lastName = "last_name"
        case cursusUsers = "cursus_users"
        case projectUsers = "projects_users"
        case evalPoints = "correction_point"
        case staff = "staff?"
    }
    
    struct Campus: Decodable {
        let city: String
    }
    struct Image: Decodable {
        let link: String?
    }
    struct Cursus: Decodable {
        let beginAt: String
        let level: Double
        let skills: [Skill]
        let grade: String?
        let cursus: CursusInfo

        enum CodingKeys: String, CodingKey {
            case beginAt = "begin_at"
            case level, skills, grade, cursus
        }
    }

    struct CursusInfo: Decodable {
        let name: String
    }
    struct ProjectUser: Decodable {
        let project: ProjectInfo
        let finalMark: Int?
        let validated: Bool?

        enum CodingKeys: String, CodingKey {
            case project
            case finalMark = "final_mark"
            case validated = "validated?"
        }
    }
    struct ProjectInfo: Decodable {
        let name: String
    }
}
