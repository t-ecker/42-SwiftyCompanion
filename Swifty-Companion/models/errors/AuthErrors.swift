//
//  AuthErrors.swift
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
    case malformedRequest
    case serverError
    case otherError(statusCode: Int)
    case notFound
    case forbiddenRequest
    case unprocessableRequest

    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "[Auth] Invalid credentials"
        case .invalidToken:
            return "[Auth] Invalid token"
        case .invalidResponse:
            return "[Auth] Invalid response"
        case .invalidURL:
            return "[Auth] Invalid URL"
        case .malformedRequest:
            return "[Auth] Malformed request"
        case .serverError:
            return "[Auth] Server error"
        case .forbiddenRequest:
            return "[Auth] Forbidden endpoint"
        case .notFound:
            return "[Auth] Not Found"
        case .unprocessableRequest:
            return "[Auth] Unprocessable Request"
        case .otherError(statusCode: let statusCode):
            return "[Auth] Server responded with status code \(statusCode)"
        }
    }
}
