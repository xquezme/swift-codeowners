//
//  Unowned.swift
//
//
//  Created by Sergei Pimenov on 8/4/24.
//

import ArgumentParser
import Glob

struct Unowned: ParsableCommand {
    public static let configuration = CommandConfiguration(abstract: "Return a list of files with no assigned owner")

    @Option(name: .shortAndLong, help: "The path of CODEOWNERS/CODENOTIFY file")
    private var filePath: String = ".github/CODEOWNERS"

    @Flag(name: .shortAndLong, help: "Include untracked files")
    private var includeUntracked: Bool = false

    mutating func run() throws {
        var untrackedFiles = [String]()

        if includeUntracked {
            untrackedFiles = try gitLsFilesUntracked().components(separatedBy: .newlines).dropLast()
        }

        let trackedFiles = try gitLsFilesTracked().components(separatedBy: .newlines).dropLast()

        let allFiles = trackedFiles + untrackedFiles

        let rules = try parseCodeowners(from: filePath).rules

        let unownedFiles = try allFiles.filter { file -> Bool in
            let isMatched = try rules.contains(where: { rule in
                try rule.pattern.match(file)
            })

            return !isMatched
        }
        
        if !unownedFiles.isEmpty {
            print(unownedFiles.sorted().joined(separator: "\n"))
        }
    }
}
