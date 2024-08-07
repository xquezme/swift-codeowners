//
//  shell.swift
//
//
//  Created by Sergey Pimenov on 8/4/24.
//

import Foundation

enum ShellError: Error {
    case uncaughtSignal
    case emptyOutput
}

@discardableResult
func shell(_ command: String) throws -> String {
    let task = Process()

    task.launchPath = "/bin/bash"
    task.arguments = ["-c", command]

    let pipe = Pipe()
    task.standardOutput = pipe
    task.standardError = pipe
    task.launch()

    let data = pipe.fileHandleForReading.readDataToEndOfFile()

    task.waitUntilExit()
    let output = String(data: data, encoding: .utf8)

    guard task.terminationStatus == 0 else {
        throw ShellError.uncaughtSignal
    }

    guard let output else {
        throw ShellError.emptyOutput
    }
    
    return output
}
