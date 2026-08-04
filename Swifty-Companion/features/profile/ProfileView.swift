//
//  ProfileView.swift
//  Swifty-Companion
//
//  Created by Tom Ecker on 26.07.26.
//
import SwiftUI

struct ProfileView: View {
    let user: UserData

    var body: some View {
        VStack(spacing: 0) {
            ProfileHeaderView(user: user)
            ProfileContentView(user: user)
        }
    }
}

struct ProfileHeaderView: View {
    let user: UserData
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: user.pictureLink)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Color.blue
            }
            .frame(width: 200, height: 200)
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
        .padding(.bottom, 24)
        .background(Color(.gray).opacity(0.1))
    }
}

struct ProfileContentView: View {
    let user: UserData
    @State private var selection: ProfileTab = .info
    
    enum ProfileTab: String, CaseIterable {
        case skills = "Skills"
        case projects = "Projects"
        case info = "Info"
    }
    
    var body: some View {
        VStack (spacing: 0){
            Picker("", selection: $selection) {
                Text("Projects").tag(ProfileTab.projects)
                Text("Info").tag(ProfileTab.info)
                Text("Skills").tag(ProfileTab.skills)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal, 32)
            .padding(.top, 16)
            .padding(.bottom, 8)
            .background(Color(.systemGroupedBackground))
            
            Group {
                switch selection {
                case .projects:
                    ProjectListView(projects: user.projects)
                case .skills:
                    SkillListView(skills: user.skills)
                case .info:
                    InfoListView(user: user)
                }
            }
            .contentMargins(.top, 0)
        }
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
