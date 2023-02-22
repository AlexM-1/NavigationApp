//
//  ProfileViewModel.swift
//  NavigationApp
//
//  Created by Alex M on 10.02.2023.
//

import Foundation
import UIKit

enum Flow {
    case userProfile
    case postAuthorProfile
}

final class ProfileViewModel {
    
    enum Action {
        case arrowForwardButtonDidTap
        case photoCellDidTap(Int)
        case photoButtonDidTap
        case viewIsReady
        case showMoreButtonDidTap(FeedPostItemInfoProtocol)
        case editButtonDidTap
        case detailedInformationButtonDidTap
        case menuDidTap(Int)
        case menuButtonDidTap
        case closeMenu
        case likeButtonDidTap(FeedPostItemInfoProtocol)
        case bookmarkButtonDidTap(FeedPostItemInfoProtocol)
        case messageButtonDidTap
        case callButtonDidTap
        case noteButtonDidTap
        case historyButtonDidTap
        case searchButtonDidTap
        
    }
    
    enum State {
        case initial
        case loading
        case loaded
        case error
        case showMenu
        case closeMenu
    }
    
    let coordinator: ProfileCoordinator
    let flow: Flow
    var menuType: MenuType = .userMenu
    let group = DispatchGroup()
    
    var user: UserProfileInfoProtocol! {
        switch flow {
        case .userProfile:
            return LocalStorage.shared.mainUser
        case .postAuthorProfile:
            return LocalStorage.shared.user
        }
    }
    
    var userPhotos: [UIImage] {
        switch flow {
        case .userProfile:
            return LocalStorage.shared.mainUserPhotos
        case .postAuthorProfile:
            return LocalStorage.shared.userPhotos
        }
    }
    
    
    var postsDaySorted: [Date: [FeedPostItemInfoProtocol]] = [:]
    var dates: [Date] = []
    
    
    var stateChanged: ((State) -> Void)?
    private(set) var state: State = .initial {
        didSet {
            stateChanged?(state)
        }
    }
    
    init(coordinator: ProfileCoordinator, flow: Flow) {
        self.coordinator = coordinator
        self.flow = flow
        
        switch self.flow {
        case .userProfile:
            LocalStorage.shared.mainUserPhotos = []
            LocalStorage.shared.mainUserPosts = []
        case .postAuthorProfile:
            LocalStorage.shared.userPhotos = []
            LocalStorage.shared.userPosts = []
        }
    }
    
    private func fetchUserPhotos() {
        group.enter()
        NetworkService.shared.getAllPhotos(userID: user.id) { images in
            guard let images = images else { return }
            switch self.flow {
            case .userProfile:
                LocalStorage.shared.mainUserPhotos = images
            case .postAuthorProfile:
                LocalStorage.shared.userPhotos = images
            }
            // блок в группе завершил выполнение
            self.group.leave()
        }
    }
    
    private func fetchUserPosts() {
        group.enter()
        NetworkService.shared.getUserPosts(userID: user.id) { posts in
            guard let posts = posts else { return }
            // сохраняем локально посты пользователя
            switch self.flow {
            case .userProfile:
                LocalStorage.shared.mainUserPosts = posts
            case .postAuthorProfile:
                LocalStorage.shared.userPosts = posts
            }
            
            // преобразуем массив постов в словарь c ключом дата
            var resultDate: [Date] = []
            var resultPosts: [Date: [FeedPostItemInfoProtocol]] = [:]
            let calendar = Calendar.current
            posts.forEach { item in
                let date = calendar.startOfDay(for: item.date)
                resultDate.append(date)
                if resultPosts.keys.contains(date) {
                    resultPosts[date]?.append(item)
                } else {
                    resultPosts[date] = [item]
                }
            }
            self.postsDaySorted = resultPosts
            
            // массив с датами постов без повторов, отсортирован
            let unique = Array(Set(resultDate)).sorted(by: >)
            self.dates = unique
            
            // блок в группе завершил выполнение
            self.group.leave()
        }
    }
    
    
    func changeState(_ action: Action) {
        switch action {
            
        case .arrowForwardButtonDidTap, .photoButtonDidTap:
            coordinator.showPhotoGallery(flow: flow)
            
        case .photoCellDidTap(let index):
            coordinator.showPhotoSlider(flow: flow, index: index)
            
        case .viewIsReady:
            self.state = .loading
            fetchUserPosts()
            fetchUserPhotos()
            group.notify(queue: .main) {
                // выполнить действия в контроллере представления
                self.state = .loaded
            }
            
            
        case .showMoreButtonDidTap(let post):
            coordinator.showPostDetail(post: post)
            
        case .editButtonDidTap:
            menuType = .userMenu
            state = .showMenu
            
            
        case .detailedInformationButtonDidTap:
            coordinator.showDetailedProfileScreen(user: user, flow: flow)
            
            
        case .menuDidTap(let index):
            switch menuType {
            case .profileMenu:
                print("in viewModel -", ProfileMenuModel(rawValue: index)?.description ?? "")
            case .userMenu:
                print("in viewModel - ", UserMenuModel(rawValue: index)?.description ?? "")
            }
            
        case .menuButtonDidTap:
            menuType = .profileMenu
            state = .showMenu
            
        case .closeMenu:
            state = .closeMenu
            
        case .likeButtonDidTap(let post):
            LocalStorage.shared.likePost(post: post)
            
        case .bookmarkButtonDidTap(let post):
            CoreDataManager.default.addPost(post: post)
            
        case .messageButtonDidTap:
            print("messageButtonDidTap")
            
        case .callButtonDidTap:
            print("callButtonDidTap")
            
        case .noteButtonDidTap:
            print("noteButtonDidTap")
            
        case .historyButtonDidTap:
            print("historyButtonDidTap")
            
        case .searchButtonDidTap:
            print("searchButtonDidTap")
        }
    }
}

