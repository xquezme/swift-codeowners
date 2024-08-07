// The Swift Programming Language
// https://docs.swift.org/swift-book

import ArgumentParser

struct SwiftCodeowners: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "A Swift command-line tool to GitHub CODEOWNERS file",
        subcommands: [Unowned.self]
    )

    init() { }
}

SwiftCodeowners.main()
