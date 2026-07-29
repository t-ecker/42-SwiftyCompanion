//
//  SearchView.swift
//  Swifty-Companion
//
//  Created by Tom Ecker on 29.07.26.
//

import SwiftUI

struct SearchView: View {
    @State private var viewModel: SearchViewModel
    @FocusState private var isSearchFocused: Bool

    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationStack {
            content
                .navigationBarTitle(Text("Search"), displayMode: .large)
                .searchable(text: $viewModel.searchText, placement: .toolbar, prompt: "Search for a user")
                .searchFocused($isSearchFocused)
                .onSubmit(of: .search) {
                    if !viewModel.searchText.isEmpty {
                        isSearchFocused = false
                        Task {
                            try await viewModel.search()
                        }
                    }
                }
                .navigationDestination(item: $viewModel.activeUser) { user in
                    ProfileView(user: user)
                }
                .alert("Error", isPresented: $viewModel.state.isError) {
                    Button("OK") {
                        if case .error(let error) = viewModel.state {
                            print(error.localizedDescription)
                        }
                    }
                } message: {
                    if case .error(let error) = viewModel.state {
                        Text(error.localizedDescription)
                    }
                }
        }
        .overlay {
            if case .loading = viewModel.state {
                ZStack {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                    
                    ProgressView("Wait...")
                        .scaleEffect(1.5)
                        .tint(.white)
                }
            }
        }
    }
    
    @ViewBuilder
    var content: some View {
        if viewModel.history.isEmpty {Text("No recent searches")} else {SearchHistory(viewModel: viewModel, isSearchFocused: isSearchFocused)}
    }
}

#Preview {
    let authService = AuthService()
    let apiService = ApiService(authService: authService)
    SearchView(viewModel: SearchViewModel(apiService: apiService))
}
