//
//  FeedCoordinator.swift
//  NavigationApp
//
//  Created by Alex M on 13.02.2023.
//


import UIKit

final class FeedCoordinator {

    private var navController: UINavigationController

    init(navController: UINavigationController) {
        self.navController = navController
    }


    func showPost(post: FeedPostItemInfoProtocol) {
        let controller = OnePostViewController()
        controller.configure(post: post)
        self.navController.pushViewController(controller, animated: true)
    }
    

    func showPostAuthorProfile() {
        let coordinator = ProfileCoordinator(navController: navController)
        let viewModel = ProfileViewModel(coordinator: coordinator, flow: .postAuthorProfile)
        let controller = ProfileViewController(viewModel: viewModel)
        self.navController.pushViewController(controller, animated: true)
    }



}

