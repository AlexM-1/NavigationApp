//
//  FeedPostItemInfo.swift
//  Navigation
//
//  Created by Alex M on 02.02.2023.
//

import Foundation

protocol FeedPostItemInfoProtocol: Codable {
    var id: String { get set }
    var date: Date { get set }
    var userImage: String { get set }
    var username: String { get set }
    var userID: String { get set }
    var profession: String { get set }
    var postText: String { get set }
    var postImage: PhotoItemInfo { get set }
    var numberOfLikes: Int { get set }
    var isLiked: Bool { get set }
    var numberOfComments: Int { get set }
    var isAddToBookmarks: Bool { get set }
    var comments: [CommentInfo]? { get set }
}


public struct FeedPostItemInfo: FeedPostItemInfoProtocol {
    var id: String
    var date: Date
    var userImage: String
    var username: String
    var userID: String
    var profession: String
    var postText: String
    var postImage: PhotoItemInfo
    var numberOfLikes: Int
    var isLiked: Bool
    var numberOfComments: Int
    var isAddToBookmarks: Bool
    var comments: [CommentInfo]?
    
}

protocol CommentInfoProtocol: Codable {
    var username: String? { get }
    var commentText: String? { get }
}

public struct CommentInfo: CommentInfoProtocol {
    var username: String?
    var commentText: String?
}



public struct PostsResponseCodable: Codable {
    var posts: [FeedPostItemInfo]
}

typealias FeedPosts = [FeedPostItemInfoProtocol]
