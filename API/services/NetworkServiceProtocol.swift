//
//  NetworkServiceProtocol.swift
//  NavigationApp
//
//  Created by Alex M on 13.02.2023.
//

import UIKit


protocol NetworkServiceProtocol {
    func fetchUserProfile(userID: String, completion: @escaping (_ responce: UserProfileInfo?) -> Void)
    func fetchUserProfile(phoneNumber: String, completion: @escaping (_ responce: UserProfileInfo?) -> Void)
    func createNewUserProfile(completion: @escaping (_ responce: UserProfileInfo?) -> Void)
    func getFeed(completion: @escaping (_ responce: FeedPosts?) -> Void)
    func getStories(completion: @escaping (_ responce: FeedStories?) -> Void)
    func loadPhotoFromUrl(imageUrl: String?, completion: @escaping (_ responce: UIImage?) -> Void)
    func getAllPhotos(userID: String, completion: @escaping (_ responce: [UIImage]?) -> Void)
    func getUserPosts(userID: String, completion: @escaping (_ responce: FeedPosts?) -> Void)
    func updateUserProfile(userID: String, profile: UserProfileInfoProtocol)
    func addPost(userID: String, post: FeedPostItemInfoProtocol)
    func addLike(userID: String, postID: String)
    func removeLike(userID: String, postID: String)
    func addComment (userID: String, postID: String)
    func removePhoto(userID: String, photoID: String)
    func addPhoto(userID: String, photo: PhotoItemInfoProtocol)
}


