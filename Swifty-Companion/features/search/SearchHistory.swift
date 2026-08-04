//
//  SearchHistory.swift
//  Swifty-Companion
//
//  Created by Tom Ecker on 29.07.26.
//

import SwiftUI

struct SearchHistory: View {
    let viewModel: SearchViewModel
    let isSearching: Bool

    var body: some View {
        List {
            Section {
                ForEach(viewModel.history) { user in
                    Button {
                        viewModel.selectUser(user: user)
                    } label: {
                        HistoryElement(user: user)
                    }
                    .buttonStyle(.plain)
                }
            } header: {
                if isSearching {
                    Text("Recent")
                } else {
                    HStack {
                        Text("Recent")
                        Spacer()
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
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
                ImageFallbackView(size: 50)
            }
            .frame(width: 50, height: 50)
            .clipShape(Circle())
            .overlay {
                Circle()
                    .strokeBorder(.separator, lineWidth: 0.5)
            }

            VStack (alignment: .leading){
                Text(user.login)
                    .font(Font.headline)
                Text(user.firstName + " " + user.lastName)
                    .font(Font.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
    }
}

struct ImageFallbackView: View {
    let size: Int
    
    var body: some View {
        ZStack {
            Rectangle().fill(.quaternary)
            Image(systemName: "person.fill")
                .font(.system(size: CGFloat(size) * 0.45))
                .foregroundStyle(.secondary)
        }
    }
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
        evalPoints: 4,
        grade: "Learner",
        start: "2024-01-15",
        level: 5.42,
        skills: [],
        projects: []
    ))
}
