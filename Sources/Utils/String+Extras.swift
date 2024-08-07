//
//  String+Extas.swift
//
//
//  Created by Sergey Pimenov on 8/6/24.
//

import Foundation

private let digitsCharacters = CharacterSet(charactersIn: "0123456789")

extension String {
    var isIntegerNumber: Bool {
        CharacterSet(charactersIn: self).isSubset(of: digitsCharacters)
    }

    var componentsSeparatedByNonEscapedWhitespace: [String] {
        let arr = Array(self)

        var elements = [String]()
        var current = ""

        for i in 0 ..< arr.count {
            if !arr[i].isWhitespace {
                current += String(arr[i])
                continue
            }

            if arr.indices.contains(i - 1), arr[i - 1] == "\\" {
                current += String(arr[i])
                continue
            }

            if !current.isEmpty {
                elements.append(current)
                current = ""
            }
        }

        if !current.isEmpty {
            elements.append(current)
        }

        return elements
    }
}
