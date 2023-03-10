//
//  ApiManager.swift
//  NavigationApp
//
//  Created by Alex M on 12.02.2023.
//

import Foundation
import UIKit


enum ApiType {
    case getUserInfo
    case getUserPosts
    case getFeed
    case getStories
    case getPhotos
    case getNewUser
    
    
    var baseURL: String {
        return "https://navigation_app.backend.com"
    }
    
    var headers: [String: String] {
        return ["access_token": "12345"]
    }
    
    var path: String {
        switch self {
        case .getUserInfo:
            return "user"
        case .getUserPosts:
            return "userposts"
        case .getFeed:
            return "feed"
        case .getPhotos:
            return "photos"
        case .getStories:
            return "stories"
        case .getNewUser:
            return "getNewUser"
        }
    }
    
    var request: URLRequest {
        let url = URL(string: path, relativeTo: URL(string: baseURL)!)!
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        request.httpMethod = "GET"
        return request
    }
}

class ApiManager: NetworkServiceProtocol {
    
    func fetchUserProfile(userID: String, completion: @escaping (UserProfileInfo?) -> Void) {
        let request = ApiType.getUserInfo.request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data,
               let user = try? JSONDecoder().decode(UserProfileInfo.self, from: data) {
                completion(user)
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
    
    func fetchUserProfile(phoneNumber: String, completion: @escaping (UserProfileInfo?) -> Void) {
        let request = ApiType.getUserInfo.request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data,
               let user = try? JSONDecoder().decode(UserProfileInfo.self, from: data) {
                completion(user)
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
    
    
    func createNewUserProfile(completion: @escaping (UserProfileInfo?) -> Void) {
        let request = ApiType.getNewUser.request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data,
               let user = try? JSONDecoder().decode(UserProfileInfo.self, from: data) {
                completion(user)
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
    
    
    func getFeed(completion: @escaping (FeedPosts?) -> Void) {
        let request = ApiType.getFeed.request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data,
               let postsResponse = try? JSONDecoder().decode(PostsResponseCodable.self, from: data) {
                completion(postsResponse.posts)
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
    
    func getStories(completion: @escaping (_ responce: FeedStories?) -> Void) {
        let request = ApiType.getStories.request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data,
               let storiesResponse = try? JSONDecoder().decode(StoriesResponseCodable.self, from: data) {
                completion(storiesResponse.stories)
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
    
    
    func loadPhotoFromUrl(imageUrl: String?, completion: @escaping (UIImage?) -> Void) {
        
        guard let imageUrl = imageUrl, let url = URL(string: imageUrl) else {
            completion(nil)
            return }
        
        // Проверка, существует ли изображение в кэше
        if let cachedResponse = URLCache.shared.cachedResponse(for: URLRequest(url: url)) {
            let image = UIImage(data: cachedResponse.data)
            completion(image)
            return
        }
        // если к кэше нет данного изображения, получаем его из сети
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] data, response, _ in
            
            if let data = data, let response = response {
                let image = UIImage(data: data)
                completion(image)
                
                // помещаем в кэш
                self?.handleLoadedImage(data: data, response: response)
            }
            
        }
        dataTask.resume()
    }
    
    // Метод, помещающий изображение в кэш
    private func handleLoadedImage(data: Data, response: URLResponse) {
        guard let responseURL = response.url else { return }
        let cachedResponse = CachedURLResponse(response: response, data: data)
        URLCache.shared.storeCachedResponse(cachedResponse, for: URLRequest(url: responseURL))
    }
    
    
    func getAllPhotos(userID: String, completion: @escaping ([UIImage]?) -> Void) {
        var images: [UIImage] = []
        let group = DispatchGroup()
        let request = ApiType.getPhotos.request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data,
               let postsResponse = try? JSONDecoder().decode(PhotosCodable.self, from: data) {
                postsResponse.photos.forEach {
                    group.enter()
                    self.loadPhotoFromUrl(imageUrl: $0.imageUrl) { image in
                        if let image = image {
                            images.append(image)
                        }
                        group.leave()
                    }
                }
                
            } else {
                completion(nil)
            }
        }
        task.resume()
        group.notify(queue: .main) {
            completion(images)
        }
    }
    
    
    func getUserPosts(userID: String, completion: @escaping (FeedPosts?) -> Void) {
        let request = ApiType.getUserPosts.request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data,
               let postsResponse = try? JSONDecoder().decode(PostsResponseCodable.self, from: data) {
                completion(postsResponse.posts)
            } else {
                completion(nil)
            }
        }
        task.resume()
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
