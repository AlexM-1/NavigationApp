//
//  PhotoItemInfoProtocol.swift
//  NavigationApp
//
//  Created by Alex M on 16.02.2023.
//

import Foundation
import CoreLocation

protocol PhotoItemInfoProtocol: Codable {
    var id: String? { get set }
    var date: Date { get set }
    var imageUrl: String? { get set }
    var image: Data? { get set }
    var name: String? { get set }
    var album: String? { get set }
    var location: LocationInfo? { get set }
}

protocol LocationInfoProtocol: Codable {
    var latitude: Double? { get set }
    var longitude: Double? { get set }
    var description: String? { get set }
}

public struct PhotoItemInfo: PhotoItemInfoProtocol {
    var id: String?
    var date: Date
    var imageUrl: String?
    var image: Data?
    var name: String?
    var album: String? 
    var location: LocationInfo?
}

struct LocationInfo: LocationInfoProtocol {
    var latitude: Double?
    var longitude: Double?
    var description: String?
}



public struct PhotosCodable: Codable {
    var photos: [PhotoItemInfo]
}

typealias Photos = [PhotoItemInfo]

