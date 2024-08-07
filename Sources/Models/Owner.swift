//
//  Owner.swift
//
//
//  Created by Sergey Pimenov on 8/11/24.
//

import Foundation

enum Owner: RawRepresentable, Equatable, Sendable {
    typealias RawValue = String

    case team(org: String, name: String)
    case email(email: String)
    case user(name: String)

    init?(rawValue: String) {
        if rawValue.hasPrefix("@") {
            let components = rawValue.components(separatedBy: "/")

            switch components.count {
            case 1:
                self = .user(
                    name: String(components[0].dropFirst())
                )
            case 2:
                self = .team(
                    org: String(components[0].dropFirst()),
                    name: components[1]
                )
            default:
                return nil
            }
        } else if rawValue.contains("@") {
            self = .email(email: rawValue)
        } else {
            return nil
        }
    }

    var rawValue: String {
        switch self {
        case let .email(email):
            email
        case let .team(org, name):
            "@\(org)/\(name)"
        case let .user(name):
            "@\(name)"
        }
    }
}
