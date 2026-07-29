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
        Text("Profile of \(user.login)")
    }
}
