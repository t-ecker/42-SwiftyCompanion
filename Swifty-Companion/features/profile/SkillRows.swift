//
//  SkillRows.swift
//  Swifty-Companion
//
//  Created by Tom Ecker on 30.07.26.
//

import SwiftUI

struct SkillRows: View {
    let skills: [Skill]

    var sortedSkills: [Skill] {
        skills.sorted { $0.level > $1.level }
    }

    var body: some View {
        if skills.isEmpty {
            ContentUnavailableView("No skills yet", systemImage: "wand.and.sparkles")
        } else {
            ForEach(sortedSkills) { skill in
                SkillElement(skill: skill)
            }
        }
    }
}

struct SkillElement: View {
    let skill: Skill

    var body: some View {
        HStack {
            Text(skill.name)
                .font(.headline)
            Spacer()
            VStack(alignment: .trailing) {
                Text(String(format: "%.2f", skill.level))
                    .font(.title2.bold())
                Text("Lvl \(Int(skill.level)) • \(Int(skill.level.truncatingRemainder(dividingBy: 1) * 100))%")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    List {
        SkillRows(skills: [
            Skill(id: 1, level: 7.2, name: "Algorithms & AI"),
            Skill(id: 2, level: 5.8, name: "Graphics"),
            Skill(id: 3, level: 3.7, name: "Unix"),
            Skill(id: 4, level: 9.1, name: "Rigor")
        ])
    }
}
