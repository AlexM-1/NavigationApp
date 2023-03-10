//
//  MenuModel.swift
//  NavigationApp
//
//  Created by Alex M on 17.02.2023.
//

import UIKit

enum ProfileMenuModel: Int, CustomStringConvertible, CaseIterable {
    case mainInfo
    case contacts
    case interests
    case education
    case career
    
    var description: String {
        switch self {
        case .mainInfo: return "mainInfo".localizable
        case .contacts: return "contacts".localizable
        case .interests: return "interests".localizable
        case .education: return "education".localizable
        case .career: return "career".localizable
        }
    }
    
    var image: UIImage {
        switch self {
        case .mainInfo: return UIImage(systemName: "list.bullet.rectangle") ?? UIImage()
        case .contacts: return UIImage(systemName: "person.2") ?? UIImage()
        case .interests: return UIImage(systemName: "crown") ?? UIImage()
        case .education: return UIImage(systemName: "graduationcap") ?? UIImage()
        case .career: return UIImage(systemName: "briefcase") ?? UIImage()
        }
    }
    
}

