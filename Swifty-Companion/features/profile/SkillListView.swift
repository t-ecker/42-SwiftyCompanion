//
//  SkillListView.swift
//  Swifty-Companion
//
//  Created by Tom Ecker on 30.07.26.
//

import SwiftUI

struct SkillListView: View {
    let skills: [Skill]
    
    var sortedSkills: [Skill] {
        skills.sorted { $0.level > $1.level }
    }
    
    var body: some View {
        List{
            ForEach(sortedSkills) { skill in
                SkillElement(skill: skill)
            }
        }
        .listStyle(.plain)
        .padding(.horizontal)
    }
}

struct SkillElement: View {
    let skill: Skill
    
    let maxSkillLvl: Double = 10
    var body: some View {
        HStack {
            Text(skill.name)
                .font(.headline)
            Spacer()
            VStack(alignment: .trailing) {
                Text(String(skill.level))
                    .font(.title2.bold())
                Text("Lvl \(Int(skill.level)) • \(Int(skill.level.truncatingRemainder(dividingBy: 1) * 100))%")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

//#Preview {
//    SkillListView(skills: [
//        Skill(id: 1, level: 7.2, name: "Algorithms & AI"),
//        Skill(id: 2, level: 5.8, name: "Graphics"),
//        Skill(id: 3, level: 3.7, name: "Unix"),
//        Skill(id: 4, level: 9.1, name: "Rigor"),
//        Skill(id: 5, level: 4.3, name: "Imperative programming")
//    ])
//}
