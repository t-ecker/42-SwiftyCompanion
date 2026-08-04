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
        case .notFound:
            return "No student with that login exists on the intra."
        case .invalidToken:
            return "The app couldn't authenticate with the 42 intra."
        case .invalidResponse:
            return "[API] Invalid response"
        case .malformedRequest:
            return "[API] Malformed request"
        case .invalidURL:
            return "[API] Invalid URL"
        case .serverError:
            return "[API] Server error"
        case .forbiddenRequest:
            return "We dont have access to that information."
        case .unprocessableRequest:
            return "[API] Unprocessable Request"
        case .otherError(statusCode: let statusCode):
            return "The 42 intra responded with status code \(statusCode)."
        }
    }
}
