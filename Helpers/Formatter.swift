//
//  Formatter.swift
//  Navigation
//
//  Created by Alex M on 01.02.2023.
//

import Foundation

// вспомогательный класс для возврата строки без учета маски

final class Formatter {
    
    static func getFormattedNumber(from number: String, withMask mask: String) -> String {
        let cleanNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        var result = ""
        var index = cleanNumber.startIndex
        for ch in mask where index < cleanNumber.endIndex {
            if ch == "#" {
                result.append(cleanNumber[index])
                index = cleanNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
}
