//
//  ApiErrors.swift
//  Swifty-Companion
//
//  Created by Tom Ecker on 27.07.26.
//

import Foundation

enum ApiError: Error, LocalizedError {
    case invalidURL
    case invalidToken
    case invalidResponse
    case malformedRequest
    case serverError
    case otherError(statusCode: Int)
    case notFound
    case forbiddenRequest
    case unprocessableRequest
    
    var errorDescription: String? {
        switch self {
        case .invalidToken:
            return "[API] Invalid token"
        case .invalidResponse:
            return "[API] Invalid response"
        case .malformedRequest:
            return "[API] Malformed request"
        case .invalidURL:
            return "[API] Invalid URL"
        case .serverError:
            return "[API] Server error"
        case .forbiddenRequest:
            return "[API] forbidden endpoint"
        case .notFound:
            return "[API] Not Found"
        case .unprocessableRequest:
            return "[API] Unprocessable Request"
        case .otherError(statusCode: let statusCode):
            return "[API] Server responded with status code \(statusCode)"
        }
    }
}
