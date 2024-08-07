//
//  git.swift
//
//
//  Created by Sergei Pimenov on 8/4/24.
//

import Foundation

func gitLsFilesUntracked() throws -> String {
    try shell("git ls-files --empty-directory --full-name --other --exclude-standard --deduplicate")
}

func gitLsFilesTracked() throws -> String {
    try shell("git ls-files --empty-directory --full-name --deduplicate")
}

func gitTopLevelDirectoryPath() throws -> String {
    try shell("git rev-parse --show-toplevel")
}
