//
//  OwnershipRule.swift
//
//
//  Created by Sergey Pimenov on 8/11/24.
//

import Foundation

struct OwnershipRule: Equatable, Sendable {
    let pattern: OwnershipRulePattern
    let owners: [Owner]
}
