//
//  ApiService.swift
//  Swifty-Companion
//
//  Created by Tom Ecker on 26.07.26.
//
import Foundation

class ApiService {
    private let authService: AuthService
    
    init(authService: AuthService) {
        self.authService = authService
    }
    
    public func getUserInfo(userName: String) async throws -> UserData {
        guard let url = URL(string: "https://api.intra.42.fr/v2/users/\(userName)") else {
            throw ApiError.invalidURL
        }
        return try await fetch(url: url)
    }
    
    private func fetch<T: Decodable>(url: URL) async throws -> T {
        let token = try await authService.getToken()
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ApiError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw ApiError.serverError(statusCode: httpResponse.statusCode)
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
}
