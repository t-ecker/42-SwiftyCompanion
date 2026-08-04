//
//  AuthService.swift
//  Swifty-Companion
//
//  Created by Tom Ecker on 26.07.26.
//

import Foundation

actor AuthService {
    private var currentToken: Token?
    private var refreshTask: Task<Token, Error>?
    
    
    public func invalidateToken() {
        currentToken = nil
        refreshTask?.cancel()
        refreshTask = nil
    }
    
    public func getToken() async throws -> String {
        if let token = currentToken, !token.isExpired {
            print("Using existing token")
            return token.accessToken
        }
        else if let existingTask = refreshTask {
            print("Using existing refresh task")
            return try await existingTask.value.accessToken
        }
        let task = Task {
            let token = try await refreshToken()
            currentToken = token
            return token
        }
        print("Creating new refresh task")
        refreshTask = task
        defer { refreshTask = nil }
        
        let accessToken = try await task.value.accessToken
        print("refrresh task done")
        return accessToken
    }
    
    private func refreshToken() async throws -> Token {
        print("Refreshing token")
        guard let url = URL(string: "https://api.intra.42.fr/oauth/token") else {throw AuthError.invalidURL}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let bodyString = "grant_type=client_credentials&client_id=\(Config.clientID)&client_secret=\(Config.clientSecret)"
        request.httpBody = bodyString.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw AuthError.invalidResponse
        }

        switch httpResponse.statusCode {
        case 200...299:
            break
        case 400:
            throw AuthError.malformedRequest
        case 401:
            throw AuthError.invalidCredentials
        case 403:
            throw AuthError.forbiddenRequest
        case 404:
            throw AuthError.notFound
        case 422:
            throw AuthError.unprocessableRequest
        case 500:
            throw AuthError.serverError
        default:
            throw AuthError.otherError(statusCode: httpResponse.statusCode)
        }
        print("token refreshed!")
        return try JSONDecoder().decode(Token.self, from: data)
    }
}
