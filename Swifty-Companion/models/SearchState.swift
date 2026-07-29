//
//  SearchState.swift
//  Swifty-Companion
//
//  Created by Tom Ecker on 29.07.26.
//

enum SearchState {
    case idle
    case loading
    case error(Error)
    
    var isError: Bool {
        get {if case .error = self {true} else {false}}
        set {if !newValue {self = .idle}}
    }
}
