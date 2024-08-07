//
//  codeowners.swift
//
//
//  Created by Sergey Pimenov on 8/4/24.
//

import Foundation

func parseCodeowners(from codeOwnersFile: String) throws -> [Line] {
    let rootFilePath = try gitTopLevelDirectoryPath().trimmingCharacters(in: .newlines)

    let fileUrl = URL(fileURLWithPath: codeOwnersFile, relativeTo: URL(fileURLWithPath: rootFilePath))

    let content = try String(contentsOfFile: fileUrl.path)

    let lines = try content.components(separatedBy: .newlines).map(Line.init(text:))

    return lines
}
