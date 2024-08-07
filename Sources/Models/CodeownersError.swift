//
//  CodeownersError.swift
//
//
//  Created by Sergey Pimenov on 8/11/24.
//

import Foundation

enum CodeownersError: Error {
    case malformedSectionName(text: String)
    case malformedSectionApprovalsCount(text: String)
    case malformedRule(text: String)
}
