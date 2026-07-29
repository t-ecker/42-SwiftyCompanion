//
//  SearchViewModel.swift
//  Swifty-Companion
//
//  Created by Tom Ecker on 29.07.26.
//

import Observation

@Observable
class SearchViewModel {
    private(set) var history: [HistoryEntry] = []
    
    public func addHistory(user: HistoryEntry) {
        if !history.contains(where: { $0.id == user.id }) {
            history.insert(user, at: 0)
        }
    }
    public func clearHistory() {
        history.removeAll()
    }
}





struct HistoryEntry: Identifiable {
    var id: String { username }
    let username: String
    let fullName: String
    let imageLink: String
}
