//
//  SearchView.swift
//  Swifty-Companion
//
//  Created by Tom Ecker on 29.07.26.
//

import SwiftUI

struct SearchView: View {
    @State private var viewModel: SearchViewModel = SearchViewModel()
    
    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Search")
        }
        .searchable(text: $viewModel.searchText)
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
                    HistoryElement(user: user)
                }
            }
            
        }
    }
}

struct HistoryElement: View {
    let user: HistoryEntry
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: user.imageLink))
                .frame(width: 50, height: 50)
            
            VStack {
                Text(user.username)
                    .font(Font.subheadline)
                Text(user.fullName)
                    .font(Font.body)
            }
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    SearchView()
}
