//
//  ProfileView.swift
//  Swifty-Companion
//
//  Created by Tom Ecker on 26.07.26.
//
import SwiftUI

struct ProfileView: View {
    let user: UserData
    @State private var selection: ProfileTab = .info

    enum ProfileTab: String, CaseIterable {
        case projects = "Projects"
        case info = "Info"
        case skills = "Skills"
    }

    var body: some View {
        List {
            Section {
                ProfileHeaderView(user: user)
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
            }

            Section {
                switch selection {
                case .projects:
                    ProjectRows(projects: user.projects)
                case .skills:
                    SkillRows(skills: user.skills)
                case .info:
                    InfoRows(user: user)
                }
            } header: {
                Picker("", selection: $selection) {
                    Text("Projects").tag(ProfileTab.projects)
                    Text("Info").tag(ProfileTab.info)
                    Text("Skills").tag(ProfileTab.skills)
                }
                .pickerStyle(.segmented)
            }
        }
        .scrollIndicators(.hidden)
        .contentMargins(.top, 0, for: .scrollContent)
    }
}

struct ProfileHeaderView: View {
    let user: UserData
    @Environment(\.verticalSizeClass) private var verticalSizeClass


    private var avatarSize: Int { verticalSizeClass == .compact ? 150 : 200 }

    var body: some View {
        VStack {
            AsyncImage(url: URL(string: user.pictureLink ?? "")) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ImageFallbackView(size: avatarSize)
            }
            .frame(width: CGFloat(avatarSize), height: CGFloat(avatarSize))
            .clipShape(Circle())
            .overlay {
                Circle()
                    .strokeBorder(.separator, lineWidth: 0.5)
            }

            Text(user.login)
                .font(Font.title.bold())
            Text("\(user.firstName) \(user.lastName)")
                .font(Font.headline.bold())

            LevelBarView(user: user)
        }
        .padding(.bottom)
    }
}


#Preview {
    let tempUser2 = UserData(
        id: "asmith",
        login: "asmith",
        email: "asmith@student.42.fr",
        pictureLink: "https://cdn.intra.42.fr/users/default.png",
        firstName: "Alice",
        lastName: "Smith",
        campusCity: "Berlin",
        evalPoints: 4,
        grade: "Learner",
        start: "2024-03-20T09:30:00.000Z",
        level: 6.25,
        skills: [
            Skill(id: 3, level: 3.7, name: "Unix"),
            Skill(id: 4, level: 7.2, name: "Rigor")
        ],
        projects: [
            Project(id: "get_next_line", finalGrade: nil, name: "get_next_line", isValidated: nil),
            Project(id: "Born2beroot", finalGrade: 84, name: "Born2beroot", isValidated: true)
        ]
    )
    ProfileView(user: tempUser2)
}
