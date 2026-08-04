//
//  LevelBarView.swift
//  Swifty-Companion
//
//  Created by Tom Ecker on 30.07.26.
//

import SwiftUI

struct LevelBarView: View {
    let user: UserData
    
    var levelProgress: Double {
        user.level - user.level.rounded(.down)
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Level: \(Int(user.level))")
                    .font(.caption.bold())
                Spacer()
                Text("\(Int(levelProgress * 100)) %")
                    .font(.caption.bold())
            }
            ProgressView(value: levelProgress)
                .scaleEffect(y: 2)
        }
        .padding(.horizontal, 48)
        .padding(.top)
    }
}
