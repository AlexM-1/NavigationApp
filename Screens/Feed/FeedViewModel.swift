//
//  FeedViewModel.swift
//  NavigationApp
//
//  Created by Alex M on 13.02.2023.
//

import Foundation


final class FeedViewModel {

    enum Action {
        case showMoreButtonDidTap(FeedPostItemInfoProtocol)
        case likeButtonDidTap(FeedPostItemInfoProtocol)
        case bookmarkButtonDidTap(FeedPostItemInfoProtocol)
        case commentButtonDidTap(FeedPostItemInfoProtocol)
        case showUserInfoDidTap(String)
        case viewIsReady
    }

    enum State {
        case initial
        case loading
        case loaded
        case error
    }

    let coordinator: FeedCoordinator
    var stories: FeedStories { LocalStorage.shared.stories }
    var postsDaySorted: [Date: [FeedPostItemInfoProtocol]] = [:]
    var dates: [Date] = []
    var stateChanged: ((State) -> Void)?
    let group = DispatchGroup()

    private(set) var state: State = .initial {
        didSet {
            stateChanged?(state)
        }
    }

    init(coordinator: FeedCoordinator) {
        self.coordinator = coordinator
    }

    private func fetchStories() {
        group.enter()
        NetworkService.shared.getStories { stories in
            guard let stories = stories else { return }
            LocalStorage.shared.stories = stories
            // блок в группе завершил выполнение
            self.group.leave()
        }
    }

    private func fetchPosts() {
        group.enter()
        NetworkService.shared.getFeed { feedPosts in
            guard let feedPosts = feedPosts else { return }

            // сохраняем локально ленту
            LocalStorage.shared.feedPosts = feedPosts

            // преобразуем массив постов в словарь c ключом дата
            var resultDate: [Date] = []
            var resultPosts: [Date: [FeedPostItemInfoProtocol]] = [:]
            let calendar = Calendar.current
            feedPosts.forEach { item in
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

        case .viewIsReady:
            self.state = .loading
            fetchStories()
            fetchPosts()
            group.notify(queue: .main) {
                // выполнить действия в контроллере представления
                self.state = .loaded
            }

        case .showMoreButtonDidTap(let post):
            coordinator.showPost(post: post)

        case .likeButtonDidTap(let post):
            LocalStorage.shared.likePost(post: post)

        case .bookmarkButtonDidTap(let post):
            CoreDataManager.default.addPost(post: post)

        case .commentButtonDidTap(let post):
            print ("commentButtonDidTap in VM, post ID \(post.id)")

        case .showUserInfoDidTap(let userID):
            self.state = .loading
            NetworkService.shared.fetchUserProfile(userID: userID) { user in
                guard let user = user else { return }
                LocalStorage.shared.user = user
                self.state = .loaded
                self.coordinator.showPostAuthorProfile()
            }
        }
    }

}



