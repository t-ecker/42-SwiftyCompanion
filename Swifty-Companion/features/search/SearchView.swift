//
//  SearchView.swift
//  Swifty-Companion
//
//  Created by Tom Ecker on 29.07.26.
//

import SwiftUI

struct SearchView: View {
    @State private var viewModel: SearchViewModel
    @State private var isSearchPresented: Bool = false

    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationStack {
            content
                .navigationBarTitle(Text("Search"), displayMode: .large)
                .searchable(text: $viewModel.searchText, isPresented: $isSearchPresented, placement: .toolbar, prompt: "search by intra name")
                .onSubmit(of: .search) {
                    if !viewModel.searchText.isEmpty {
                        Task {
                            await viewModel.search()
                        }
                    }
                }
                .navigationDestination(item: $viewModel.activeUser) { user in
                    ProfileView(user: user)
                }
                .onChange(of: viewModel.activeUser) {
                    isSearchPresented = false
                }
                .toolbar { trailingToolbarItem }
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
        .tint(.black)
        .overlay {
            if case .loading = viewModel.state {
                ZStack {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                    
                    ProgressView()
                        .scaleEffect(1.5)
                        .tint(.white)
                }
            }
        }
    }
    
    @ViewBuilder
    private var content: some View {
        if viewModel.history.isEmpty {
            ContentUnavailableView {
                Label("Find a Student", systemImage: "person.crop.circle.badge.questionmark")
            } description: {
                Text("Search any 42 intra login")
            }
        } else {
            SearchHistory(viewModel: viewModel, isSearching: isSearchPresented)
        }
    }
    private var trailingToolbarItem: some ToolbarContent {
        ToolbarItem (placement: .topBarTrailing) {
            if !viewModel.history.isEmpty {
                Menu {
                    Button("Clear Recents", systemImage: "trash", role: .destructive) {
                        withAnimation(.smooth) { viewModel.clearHistory() }
                    }
                } label: {
                    Label("More", systemImage: "ellipsis")
                }
            }
        }
    }
}


#Preview {
    let authService = AuthService()
    let apiService = ApiService(authService: authService)
    SearchView(viewModel: SearchViewModel(apiService: apiService))
}
