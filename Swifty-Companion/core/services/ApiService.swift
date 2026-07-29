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
        print("getting user info")
        guard let url = URL(string: "https://api.intra.42.fr/v2/users/\(userName)") else {
            throw ApiError.invalidURL
        }
        return try await fetch(url: url)
    }
    
    private func fetch<T: Decodable>(url: URL, retry: Bool = false) async throws -> T {
        print("start fetching \(url)")
        let token = try await authService.getToken()
        print("using token")
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        print("fetched real url")
        guard let httpResponse = response as? HTTPURLResponse else {
            print("invalid response")
            throw ApiError.invalidResponse
        }
        switch httpResponse.statusCode {
        case 200...299:
            break
        case 400:
            throw ApiError.malformedRequest
        case 401:
            if (retry) {
                throw ApiError.invalidToken
            }
            await authService.invalidateToken()
            return try await fetch(url: url, retry: true)
        case 403:
            throw ApiError.forbiddenRequest
        case 404:
            throw ApiError.notFound
        case 422:
            throw ApiError.unprocessableRequest
        case 500:
            throw ApiError.serverError
        default:
            throw ApiError.otherError(statusCode: httpResponse.statusCode)
        }
        
//        return try JSONDecoder().decode(T.self, from: data)
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch let decodingError as DecodingError {
            print("DECODING FEHLER: \(decodingError)")
            throw decodingError
        }
    }
}
