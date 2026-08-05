//
//  Config.swift
//  Swifty-Companion
//
//  Created by Tom Ecker on 27.07.26.
//

import Foundation

enum Env {
    nonisolated static private let values: [String: String] = {
        guard let url = Bundle.main.url(forResource: ".env", withExtension: nil),
              let content = try? String(contentsOf: url, encoding: .utf8)
        else { return [:] }

        var dict: [String: String] = [:]
        for line in content.split(separator: "\n") {
            let trimmed = line.trimmingCharacters(in: .whitespaces)
            
            guard !trimmed.isEmpty, !trimmed.hasPrefix("//") else { continue }
            
            let parts = trimmed.split(separator: "=", maxSplits: 1)
            
            guard parts.count == 2 else { continue }
            
            dict[String(parts[0]).trimmingCharacters(in: .whitespaces)] =
                String(parts[1]).trimmingCharacters(in: .whitespaces)
        }
        return dict
    }()

    nonisolated static subscript(_ key: String) -> String? { values[key] }
}
