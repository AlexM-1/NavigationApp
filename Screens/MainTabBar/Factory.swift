//
//  Factory.swift
//  Navigation
//
//  Created by Alex M on 02.02.2023.
//


import UIKit

final class Factory {
    
    enum Flow {
        case profile
        case feed
        case favorite
    }
    
    let navigationController: UINavigationController = UINavigationController()
    let flow: Flow
    
    init(flow: Flow) {
        self.flow = flow
        startModule()
    }
    
    func startModule() {
        switch flow {
        case .profile:
            let coordinator = ProfileCoordinator(navController: navigationController)
            let viewModel = ProfileViewModel(coordinator: coordinator, flow: .userProfile)
            let controller = ProfileViewController(viewModel: viewModel)
            navigationController.tabBarItem = UITabBarItem(title: "Profile".localizable, image: UIImage(named: "userIcon"), selectedImage: nil)
            navigationController.setViewControllers([controller], animated: true)
            
            
        case .feed:
            let coordinator = FeedCoordinator(navController: navigationController)
            let viewModel = FeedViewModel(coordinator: coordinator)
            let controller = FeedViewController(viewModel: viewModel)
            navigationController.tabBarItem = UITabBarItem(title: "Main".localizable, image: UIImage(named: "homeIcon"), selectedImage: nil)
            navigationController.setViewControllers([controller], animated: true)
            
        case .favorite:
            
            let controller = FavoriteViewController()
            navigationController.tabBarItem = UITabBarItem(title: "Favorite".localizable, image: UIImage(named: "likeIcon"), selectedImage: nil)
            navigationController.setViewControllers([controller], animated: true)
            
        }
    }
}


