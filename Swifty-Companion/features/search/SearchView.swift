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
                    Button {
                        print("show history user \(user.login)")
                        viewModel.selectUser(user: user)
                    } label: {
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
            AsyncImage(url: URL(string: user.pictureLink)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Color.gray
            }
            .frame(width: 50, height: 50)
            .clipShape(Circle())
            
            VStack (alignment: .leading){
                Text(user.login)
                    .font(Font.headline)
                Text(user.firstName + " " + user.lastName)
                    .font(Font.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    let authService = AuthService()
    let apiService = ApiService(authService: authService)
    SearchView(viewModel: SearchViewModel(apiService: apiService))
}

#Preview {
    HistoryElement(user: UserData(
        id: "jdoe",
        login: "jdoe",
        email: "jdoe@student.42.fr",
        pictureLink: "https://cdn.intra.42.fr/users/small_jdoe.jpg",
        firstName: "John",
        lastName: "Doe",
        campusCity: "Berlin",
        start: "2024-01-15",
        level: 5.42,
        skills: [],
        projects: []
    ))
}
