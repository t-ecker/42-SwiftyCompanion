//
//  Swifty_CompanionApp.swift
//  Swifty-Companion
//
//  Created by Tom Ecker on 26.07.26.
//

import SwiftUI

@main
struct Swifty_CompanionApp: App {
    let apiService = ApiService(authService: AuthService())
    
    var body: some Scene {
        WindowGroup {
            SearchView(viewModel: SearchViewModel(apiService: apiService))
        }
    }
}
