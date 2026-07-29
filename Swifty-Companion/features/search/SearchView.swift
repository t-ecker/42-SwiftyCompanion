//
//  SearchView.swift
//  Swifty-Companion
//
//  Created by Tom Ecker on 29.07.26.
//

import SwiftUI

struct SearchView: View {
    @State private var viewModel: SearchViewModel
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Search")
                .searchable(text: $viewModel.searchText, placement: .toolbar, prompt: "Search for a user")
                .onSubmit(of: .search) {
                    if !viewModel.searchText.isEmpty {
                        Task {
                            try await viewModel.search()
                        }
                    }
                }
                .navigationDestination(for: UserData.self) { user in
                    ProfileView(user: user)
                }
        }
    }
    
    @ViewBuilder
    var content: some View {
        if viewModel.history.isEmpty {Text("No recent searches")} else {SearchHistory(viewModel: viewModel)}
    }
}

struct SearchHistory: View {
    let viewModel: SearchViewModel
    
    var body: some View {
        VStack {
            HStack {
                Text("Recent Searches")
                    .font(.subheadline)
                Spacer()
                Button("Clear all") {
                    viewModel.clearHistory()
                }
            }
            .padding(16)
            
            List {
                ForEach(viewModel.history) { user in
                    NavigationLink(value: user) {
                        HistoryElement(user: user)
                    }
                    
                }
            }
            
        }
    }
}

struct HistoryElement: View {
    let user: UserData
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: user.pictureLink))
                .frame(width: 50, height: 50)
            
            VStack {
                Text(user.login)
                    .font(Font.subheadline)
                Text(user.firstName + " " + user.lastName)
                    .font(Font.body)
            }
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    let authService = AuthService()
    let apiService = ApiService(authService: authService)
    SearchView(viewModel: SearchViewModel(apiService: apiService))
}
