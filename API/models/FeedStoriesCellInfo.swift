//
//  FeedStoriesCellInfo.swift
//  Navigation
//
//  Created by Alex M on 02.02.2023.
//

import Foundation

protocol FeedStoriesItemCellInfoProtocol: Codable {
    var image: String { get set }
    var username: String { get set }
    var isAddButtonVisible: Bool { get set }
    var isNewStory: Bool { get set }
    
}

public struct FeedStoriesItemCellInfo: FeedStoriesItemCellInfoProtocol {
    var image: String
    var username: String
    var isAddButtonVisible: Bool
    var isNewStory: Bool
}

public struct StoriesResponseCodable: Codable {
    var stories: [FeedStoriesItemCellInfo]
}

typealias FeedStories = [FeedStoriesItemCellInfoProtocol]


