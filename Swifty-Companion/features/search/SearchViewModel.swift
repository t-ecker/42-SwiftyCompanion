//
//  SearchViewModel.swift
//  Swifty-Companion
//
//  Created by Tom Ecker on 29.07.26.
//

import Observation

@Observable
class SearchViewModel {
    private(set) var history: [UserData] = []
    var searchText: String = ""
    private let apiService: ApiService
    var isLoading: Bool = false
    var activeUser: UserData? = nil
    
    init(apiService: ApiService) {
        self.apiService = apiService
    }
    
    public func addHistory(user: UserData) {
        if !history.contains(where: { $0.id == user.id }) {
            history.insert(user, at: 0)
        }
    }
    public func clearHistory() {
        history.removeAll()
    }
    
    public func selectUser (user: UserData) {
        activeUser = user
    }
    
    public func search() async throws {
        isLoading = true
        let profileInfo = try await apiService.getUserInfo(userName: searchText)
        isLoading = false
        addHistory(user: profileInfo)
        activeUser = profileInfo
    }
}
