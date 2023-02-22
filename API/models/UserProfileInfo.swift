//
//  UserProfileInfo.swift
//  NavigationApp
//
//  Created by Alex M on 05.02.2023.
//

import Foundation

protocol UserProfileInfoProtocol: Codable {
    
    var id: String { get }
    var publicName: String? { get set }
    var userImage: String? { get set }
    var name: String? { get set }
    var surname: String? { get set }
    var dateOfBirth: String? { get set }
    var isMale: Bool? { get set }
    var homeСity: String? { get set }
    var profession: String? { get set }
    var photos: Photos { get set }
    var publications: Int { get set }
    var subscriptions: Int { get set }
    var subscribers: Int { get set }
    
}


public struct UserProfileInfo: UserProfileInfoProtocol {
    var id: String
    var publicName: String?
    var userImage: String?
    var name: String?
    var surname: String?
    var dateOfBirth: String?
    var isMale: Bool? 
    var homeСity: String?
    var profession: String?
    var photos: Photos
    var publications: Int
    var subscriptions: Int
    var subscribers: Int
}

