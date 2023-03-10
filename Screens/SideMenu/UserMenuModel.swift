//
//  UserMenuModel.swift
//  NavigationApp
//
//  Created by Alex M on 19.02.2023.
//


import UIKit

enum UserMenuModel: Int, CustomStringConvertible, CaseIterable {
    case bookmarks
    case liked
    case files
    case archives
    case settings

    var description: String {
        switch self {
        case .bookmarks: return "bookmarks".localizable
        case .liked: return "liked".localizable
        case .files: return "files".localizable
        case .archives: return "archives".localizable
        case .settings: return "settings".localizable
        }
    }

    var image: UIImage {
        switch self {
        case .bookmarks: return UIImage(systemName: "star") ?? UIImage()
        case .liked: return UIImage(systemName: "heart") ?? UIImage()
        case .files: return UIImage(systemName: "tray.and.arrow.up") ?? UIImage()
        case .archives: return UIImage(systemName: "link") ?? UIImage()
        case .settings: return UIImage(systemName: "gearshape") ?? UIImage()
        }
    }

}


