//
//  AuthErrors.swift
//  Swifty-Companion
//
//  Created by Tom Ecker on 27.07.26.
//

import Foundation

enum ApiError: Error, LocalizedError {
    case invalidURL
    case invalidToken
    case invalidResponse
    case serverError(statusCode: Int)
    
    var errorDescription: String? {
        switch self {
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
