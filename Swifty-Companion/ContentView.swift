//
//  ContentView.swift
//  Swifty-Companion
//
//  Created by Tom Ecker on 27.07.26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Config-Test")
                .font(.headline)

            Text(Config.clientID)
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
