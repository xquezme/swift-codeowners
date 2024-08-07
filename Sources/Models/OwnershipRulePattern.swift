//
//  OwnershipRulePattern.swift
//
//
//  Created by Sergey Pimenov on 8/11/24.
//

import Foundation
import Glob

enum OwnershipRulePattern: Equatable {
    case absoluteFilePath(path: String)
    case absoluteDirectoryPath(path: String)
    case glob(pattern: String)

    init(text: String) {
        // Absolute paths
        if text.hasPrefix("/") {
            if !text.contains("*") {
                if text.hasSuffix("/") {
                    self = .absoluteDirectoryPath(path: text)
                    return
                }

                let url = URL(fileURLWithPath: text)

                if !url.pathExtension.isEmpty {
                    self = .absoluteFilePath(path: text)
                    return
                }
            }

            self = .glob(pattern: text)
            return
        }

        self = .glob(pattern: "**\(text)")
    }

    func match(_ pathToMatch: String) throws -> Bool {
        switch self {
        case let .absoluteFilePath(path):
            return path == pathToMatch
        case let .absoluteDirectoryPath(path):
            return pathToMatch.hasPrefix(path)
        case let .glob(pattern):
            var pattern = pattern
            
            if pattern.hasPrefix("/") {
                pattern = pattern + "**"
            } else if pattern.hasSuffix("**/*") {
                pattern.removeLast(4)
                pattern = pattern + "**"
            }

            let glob = try Glob.Pattern(pattern)
            
            if glob.match(pathToMatch) {
                return true
            }

            if pattern.contains("/**/") {
                let glob = try Glob.Pattern(pattern.replacingOccurrences(of: "/**/", with: "/"))
                return glob.match(pathToMatch)
            }

            return false
        }
    }
}
