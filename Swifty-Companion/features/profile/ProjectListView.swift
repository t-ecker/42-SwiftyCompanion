//
//  ProjectListView.swift
//  Swifty-Companion
//
//  Created by Tom Ecker on 30.07.26.
//

import SwiftUI

struct ProjectListView: View {
    let projects: [Project]
    
    var body: some View {
        List{
            if projects.isEmpty {
                ContentUnavailableView("No projects yet", systemImage: "folder.badge.questionmark")
            } else {
                ForEach(projects) { project in
                    ProjectElement(project: project)
                }
            }
        }
    }
}

struct ProjectElement: View {
    let project: Project
    
    var body: some View {
        HStack {
            Text(project.name)
                .font(.headline)
            Spacer()
            if let grade = project.finalGrade {
                Text("\(grade)")
                    .font(.caption.bold())
                    .foregroundStyle(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .fill(project.isValidated == true ? .green : .red)
                    )
                    .overlay(alignment: .topTrailing) {
                        if grade == 125 {
                            Image(systemName: "star.fill")
                                .foregroundStyle(.yellow)
                                .font(.caption2)
                                .offset(x: 6, y: -6)
                        }
                    }
            } else {
                Text("in progress")
                    .font(.caption.bold())
            }
        }
    }
}

//#Preview {
//    ProjectListView()
//}
#Preview {
    ProjectListView(projects: [
//        Project(id: "libft", finalGrade: 125, name: "Libft", isValidated: true),
//        Project(id: "ft_printf", finalGrade: 100, name: "ft_printf", isValidated: true),
//        Project(id: "get_next_line", finalGrade: 84, name: "get_next_line", isValidated: true),
//        Project(id: "born2beroot", finalGrade: 95, name: "Born2beroot", isValidated: true),
//        Project(id: "pipex", finalGrade: nil, name: "pipex", isValidated: nil)
    ])
}

