//
//  Token.swift
//  Swifty-Companion
//
//  Created by Tom Ecker on 27.07.26.
//

import Foundation

nonisolated struct Token: Codable {
    let accessToken: String
    let expiresIn: Int
    let createdAt: Int
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expiresIn = "expires_in"
        case createdAt = "created_at"
    }
    
    var isExpired: Bool {
        let expirationDate = Date(timeIntervalSince1970: TimeInterval(createdAt + expiresIn))
        let buffer: TimeInterval = 60
        return Date() >= expirationDate.addingTimeInterval(-buffer)
    }
}
