//
//  ApiErrors.swift
//  Swifty-Companion
//
//  Created by Tom Ecker on 27.07.26.
//

import Foundation

enum AuthError: Error, LocalizedError {
    case invalidCredentials
    case invalidToken
    case invalidResponse
    case invalidURL
    case serverError(statusCode: Int)
    
    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "Invalid credentials"
        case .invalidToken:
            return "Invalid token"
        case .invalidResponse:
            return "Invalid response"
        case .invalidURL:
            return "Invalid URL"
        case .serverError(statusCode: let statusCode):
            return "Server error with status code \(statusCode)"
        }
    }
}
