//
//  Line.swift
//  
//
//  Created by Sergey Pimenov on 8/11/24.
//

import Foundation

enum Line: Equatable, Sendable {
    case empty
    case comment(text: String)
    case section(name: String, approvalsCount: Int?, isOptional: Bool, comment: String?)
    case rule(rule: OwnershipRule, comment: String?)

    private init(sectionText text: String, comment: String?) throws {
        var text = text

        guard text.hasSuffix("]") else {
            throw CodeownersError.malformedSectionName(text: text)
        }

        let isOptional = text.hasPrefix("^")
        var approvalsCount: Int?

        guard let nameStartIndex = text.firstIndex(of: "["), let nameEndIndex = text.firstIndex(of: "]") else {
            throw CodeownersError.malformedSectionName(text: text)
        }

        let name = String(text[text.index(nameStartIndex, offsetBy: 1)..<nameEndIndex])

        text = String(text[text.index(nameEndIndex, offsetBy: 1)..<text.endIndex])

        if let countStartIndex = text.firstIndex(of: "["), let countEndIndex = text.firstIndex(of: "]") {
            let approvalsCountText = String(text[text.index(countStartIndex, offsetBy: 1)..<countEndIndex])

            guard approvalsCountText.isIntegerNumber, let count = Int(approvalsCountText) else {
                throw CodeownersError.malformedSectionApprovalsCount(text: text)
            }

            approvalsCount = count
        }

        self = .section(name: name, approvalsCount: approvalsCount, isOptional: isOptional, comment: comment)
    }

    private init(ruleText text: String, comment: String?) throws {
        let elements = text.componentsSeparatedByNonEscapedWhitespace

        guard !elements.isEmpty else {
            throw CodeownersError.malformedRule(text: text)
        }

        let path = elements[0]
        var owners = [Owner]()

        for i in 1..<elements.count {
            if let owner = Owner(rawValue: elements[i]) {
                owners.append(owner)
            }
        }

        let rulePattern = OwnershipRulePattern(text: path)
        let rule = OwnershipRule(pattern: rulePattern, owners: owners)

        self = .rule(rule: rule, comment: comment)
    }

    init(text: String) throws {
        var comment: String?
        var text = text.trimmingCharacters(in: .whitespacesAndNewlines)

        if let index = text.firstIndex(of: "#") {
            comment = String(text[text.index(index, offsetBy: 1)..<text.endIndex]).trimmingCharacters(in: .whitespacesAndNewlines)
            text = String(text[text.startIndex..<index]).trimmingCharacters(in: .whitespacesAndNewlines)
        }

        if text.isEmpty {
            self = if let comment {
                .comment(text: comment)
            } else {
                .empty
            }
            return
        }

        if text.hasPrefix("[") || text.hasPrefix("^[") {
            try self.init(sectionText: text, comment: comment)
            return
        }

        try self.init(ruleText: text, comment: comment)
    }
}

extension Array where Element == Line {
    var rules: [OwnershipRule] {
        compactMap { line in
            switch line {
            case let .rule(rule, _):
                rule
            default:
                nil
            }
        }
    }
}
