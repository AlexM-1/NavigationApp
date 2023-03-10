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
        let thousand = Double(self) / 1000
        let million = Double(self) / 1_000_000
        if million >= 1 {
            return "\(String(format: "%.1f", million)) " + "million".localizable
        }
        else if thousand >= 1 {
            return "\(String(format: "%.1f", thousand)) " + "thousand".localizable
        }
        else {
            return "\(self)"
        }
    }
}


extension Int {
    var rounded: String {
        let thousand = Double(self) / 1000
        let million = Double(self) / 1_000_000
        if million >= 1 {
            return "\(String(format: "%.1f", million))" + "M"
        }
        else if thousand >= 1 {
            return "\(String(format: "%.1f", thousand))" + "K"
        }
        else {
            return "\(self)"
        }
    }
}


