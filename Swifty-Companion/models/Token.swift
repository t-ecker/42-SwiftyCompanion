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

    let receivedAt: Date = Date()

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expiresIn = "expires_in"
    }

    var isExpired: Bool {
        let buffer: TimeInterval = 60
        return Date() >= receivedAt.addingTimeInterval(TimeInterval(expiresIn) - buffer)
    }
}
