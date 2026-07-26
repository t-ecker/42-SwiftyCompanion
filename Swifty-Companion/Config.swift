//
//  Config.swift
//  Swifty-Companion
//
//  Created by Tom Ecker on 27.07.26.
//

import Foundation

enum Config {
    static var clientID: String {
        guard let value = Bundle.main.object(forInfoDictionaryKey: "CLIENT_ID") as? String,
              !value.isEmpty else {
            fatalError("CLIENT_ID missing, check Secrets.xcconfig")
        }
        return value
    }

    static var clientSecret: String {
        guard let value = Bundle.main.object(forInfoDictionaryKey: "CLIENT_SECRET") as? String,
              !value.isEmpty else {
            fatalError("CLIENT_SECRET missing, check Secrets.xcconfig")
        }
        return value
    }
}
