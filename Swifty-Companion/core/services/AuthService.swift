//
//  authService.swift
//  Swifty-Companion
//
//  Created by Tom Ecker on 26.07.26.
//

import Foundation

actor AuthService {
    private var currentToken: Token?
    private var refreshTask: Task<Token, Error>?
    
    
    public func getToken() async throws -> String {
        if let token = currentToken, !token.isExpired {
            return token.accessToken
        }
        else if let existingTask = refreshTask {
            return try await existingTask.value.accessToken
        }
        let task = Task {
            let token = try await refreshToken()
            currentToken = token
            return token
        }
        refreshTask = task
        defer { refreshTask = nil }
        
        let accessToken = try await task.value.accessToken
        return accessToken
    }
    
    private func refreshToken() async throws -> Token {
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

        guard (200...299).contains(httpResponse.statusCode) else {
            throw AuthError.serverError(statusCode: httpResponse.statusCode)
        }
        
        return try JSONDecoder().decode(Token.self, from: data)
    }
}
