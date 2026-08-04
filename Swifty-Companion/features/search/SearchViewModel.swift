//
//  SearchViewModel.swift
//  Swifty-Companion
//
//  Created by Tom Ecker on 29.07.26.
//

import Observation
import Foundation

@Observable
class SearchViewModel {
    var searchText: String = ""
    var activeUser: UserData? = nil
    private let apiService: ApiService
    private(set) var history: [UserData] = []
    var state: SearchState = .idle
    
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
    
    public func search() async {
        print("Searching for \(searchText)")
        state = .loading
        do {
            let profileInfo = try await apiService.getUserInfo(userName: searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased())
            print(profileInfo)
            addHistory(user: profileInfo)
            activeUser = profileInfo
            state = .idle
            searchText = ""
            print("Found user: \(profileInfo.login)")
        } catch {
            state = .error(error)
        }
    }
}
