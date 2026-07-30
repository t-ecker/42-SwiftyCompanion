//
//  InfoListView.swift
//  Swifty-Companion
//
//  Created by Tom Ecker on 30.07.26.
//

import SwiftUI

struct InfoListView: View {
    let user: UserData
    
    var formattedStartDate: String {
        guard let date = try? Date(user.start, strategy: Date.ISO8601FormatStyle(includingFractionalSeconds: true)) else {
            return user.start
        }
        return date.formatted(date: .abbreviated, time: .omitted)
    }
    
    var body: some View {
        List {
            InfoElement(category: "Status", info: user.grade)
            InfoElement(category: "Eval Points", info: String(user.evalPoints))
            InfoElement(category: "E-Mail", info: user.email)
            InfoElement(category: "Campus", info: user.campusCity)
            InfoElement(category: "Start Date", info: formattedStartDate)
                
        }
        .listStyle(.plain)
        .padding(.horizontal)
    }
}

struct InfoElement: View {
    let category: String
    let info: String
    
    var body: some View {
        HStack {
            Text(category)
                .font(.body)
                .foregroundStyle(.secondary)
            Spacer()
            Text(info)
                .font(.body.weight(.medium))
        }
    }
}

//#Preview {
//    InfoListView()
//}
