//
//  Extensions.swift
//  NavigationApp
//
//  Created by Alex M on 03.02.2023.
//

import Foundation
import UIKit

extension String {
    var localizable: String {
        NSLocalizedString(self, comment: "")
    }

}


extension Int {
    var roundedWithAbbreviations: String {
        let thousand = self / 1000
        let million = self / 1_000_000
        if million >= 1 {
            return "\(million) " + "million".localizable
        }
        else if thousand >= 1 {
            return "\(thousand) " + "thousand".localizable
        }
        else {
            return "\(self)"
        }
    }
}


extension Int {
    var rounded: String {
        let thousand = self / 1000
        let million = self / 1_000_000
        if million >= 1 {
            return "\(million)" + "M"
        }
        else if thousand >= 1 {
            return "\(thousand)" + "K"
        }
        else {
            return "\(self)"
        }
    }
}


