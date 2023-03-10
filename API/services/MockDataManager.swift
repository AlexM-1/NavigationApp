//
//  MockDataManager.swift
//  NavigationApp
//
//  Created by Alex M on 13.02.2023.
//

import Foundation
import UIKit

class MockDataManager: NetworkServiceProtocol {
    
    private var imageCache = NSCache<NSString, UIImage>()
    
    func fetchUserProfile(userID: String, completion: @escaping (_ responce: UserProfileInfo?) -> Void) {
        delay(0.5) {
            let user = MockModel.shared.users.first { $0.id == userID }
            guard let user = user else {
                completion(nil)
                return
            }
            completion(user)
        }
    }
    
    func fetchUserProfile(phoneNumber: String, completion: @escaping (_ responce: UserProfileInfo?) -> Void) {
        delay(0.5) {
            let user = MockModel.shared.testUser
            completion(user)
        }
    }
    
    
    func createNewUserProfile(completion: @escaping (_ responce: UserProfileInfo?) -> Void) {
        delay(0.5) {
            let user = MockModel.shared.newUser
            MockModel.shared.addUser(user: user)
            completion(user)
        }
    }
    
    func getFeed(completion: @escaping (_ responce: FeedPosts?) -> Void) {
        delay(0.5) {
            let responce = MockModel.shared.feedPosts
            completion(responce)
        }
    }
    
    
    func getUserPosts(userID: String, completion: @escaping (_ responce: FeedPosts?) -> Void) {
        delay(0.5) {
            let posts = MockModel.shared.feedPosts.filter { $0.userID == userID }
            completion(posts)
        }
    }
    
    

    func getStories(completion: @escaping (_ responce: FeedStories?) -> Void) {
        delay(0.5) {
            let responce = MockModel.shared.feedStories
            completion(responce)
        }
    }
    
    func loadPhotoFromUrl(imageUrl: String?, completion: @escaping (UIImage?) -> Void) {
        // имитация задержки ответа
        let delayFromServer = 0.2
        
        guard let imageUrl = imageUrl, let url = URL(string: imageUrl) else {
            completion(nil)
            return }
        
        // проверить есть ли озображение в кэш
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            completion(cachedImage)
        } else {
            
            // если нет загружаем
            DispatchQueue.global().asyncAfter(deadline: .now() + delayFromServer) {
                let name = url.lastPathComponent
                if let image = UIImage(named: name)
                {
                    //сохраняем в кэш
                    self.imageCache.setObject(image, forKey: url.absoluteString as NSString)
                    completion(image)
                } else {
                    completion(nil)
                }
            }
        }
    }
    
    
    func getAllPhotos(userID: String, completion: @escaping ([UIImage]?) -> Void) {
        delay(0.5) {
            
            struct ImageDated {
                let image: UIImage
                let date: Date
            }
            
            var responce: [ImageDated] = []
            
            let user = MockModel.shared.users.first { $0.id == userID }
            guard let user = user else {
                completion(nil)
                return
            }
            
            let photos = user.photos
            print("photos to load - ", photos.count)
            
            let group = DispatchGroup()
            photos.forEach { photo in
                group.enter()
                self.loadPhotoFromUrl(imageUrl: photo.imageUrl) { image in
                    if let image = image {
                        DispatchQueue.main.async {
                            responce.append(ImageDated(image: image, date: photo.date))
                        }
                        
                    }
                    group.leave()
                }
                
            }
            
            group.notify(queue: .main) {
                
                print("photos loaded - ", responce.count)
                let result = responce.sorted { $0.date > $1.date }
                
                completion(result.map { imageDated in imageDated.image
                })
                
            }
            
        }
    }
    
    
    func updateUserProfile(userID: String, profile: UserProfileInfoProtocol) {
    }
    
    func addPost(userID: String, post: FeedPostItemInfoProtocol) {
    }
    
    func addLike(userID: String, postID: String) {
    }
    
    func removeLike(userID: String, postID: String) {
    }
    
    func addComment(userID: String, postID: String) {
    }
    
    func removePhoto(userID: String, photoID: String) {
    }
    
    func addPhoto(userID: String, photo: PhotoItemInfoProtocol) {
    }
    
}

