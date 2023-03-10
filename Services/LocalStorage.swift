//
//  LocalStorage.swift
//  NavigationApp
//
//  Created by Alex M on 12.02.2023.
//

import Foundation
import UIKit


final class LocalStorage {
    
    static let shared = LocalStorage()
    
    var mainUser: UserProfileInfoProtocol?
    var mainUserPhotos: [UIImage] = []
    var mainUserPosts: [FeedPostItemInfoProtocol] = []
    
    var feedPosts: [FeedPostItemInfoProtocol] = []
    var stories: FeedStories = []
    
    var user: UserProfileInfoProtocol?
    var userPhotos: [UIImage] = []
    var userPosts: [FeedPostItemInfoProtocol] = []
    
    
    func deletePhoto(index: Int) {
        if index < mainUserPhotos.count {
            self.mainUserPhotos.remove(at: index)
        }
    }
    
    func appendPhoto(image: UIImage) {
        self.mainUserPhotos.append(image)
    }
    
    func likePost(post: FeedPostItemInfoProtocol) {
        if let index = feedPosts.firstIndex(where: { $0.id == post.id }) {
            if self.feedPosts[index].isLiked {
                self.feedPosts[index].numberOfLikes -= 1
            } else {
                self.feedPosts[index].numberOfLikes += 1
            }
            self.feedPosts[index].isLiked.toggle()
            print(self.feedPosts[index].numberOfLikes)
            print(self.feedPosts[index].isLiked)
        }
        
        if let index = userPosts.firstIndex(where: { $0.id == post.id }) {
            if self.userPosts[index].isLiked {
                self.userPosts[index].numberOfLikes -= 1
            } else {
                self.userPosts[index].numberOfLikes += 1
            }
            self.userPosts[index].isLiked.toggle()
            print(self.userPosts[index].numberOfLikes)
            print(self.userPosts[index].isLiked)
        }
        
        
    }
    
    func getLikeState(post: FeedPostItemInfoProtocol) -> Bool {
        if let index = feedPosts.firstIndex(where: { $0.id == post.id }) {
            return self.feedPosts[index].isLiked ? true : false
        }
        return false
    }
    
    func getLikeCount(post: FeedPostItemInfoProtocol) -> Int {
        if let index = feedPosts.firstIndex(where: { $0.id == post.id }) {
            return self.feedPosts[index].numberOfLikes
        }
        return 0
    }
    
    
}

