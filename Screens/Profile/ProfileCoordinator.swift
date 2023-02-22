//
//  ProfileCoordinator.swift
//  NavigationApp
//
//  Created by Alex M on 12.02.2023.
//

import UIKit

final class ProfileCoordinator {
    
    private var navController: UINavigationController
    
    init(navController: UINavigationController) {
        self.navController = navController
    }
    
    func showPhotoGallery(flow: Flow) {
        let viewModel = PhotoGalleryViewModel(coordinator: self, flow: flow)
        let controller = PhotoGalleryViewController(viewModel: viewModel)
        self.navController.pushViewController(controller, animated: true)
    }
    
    
    func showPhotoSlider(flow: Flow, index: Int) {
        let viewModel = PhotoSliderViewModel(flow: flow)
        let controller = PhotoSliderViewController(index: index, viewModel: viewModel)
        self.navController.pushViewController(controller, animated: true)
    }


    func showPostDetail(post: FeedPostItemInfoProtocol) {
        let controller = OnePostViewController()
        controller.configure(post: post)
        self.navController.pushViewController(controller, animated: true)
    }


    func showDetailedProfileScreen(user: UserProfileInfoProtocol, flow: Flow) {
        let viewModel = DetailedProfileViewModel(coordinator: self, user: user, flow: flow)
        let controller = DetailedProfileViewController(viewModel: viewModel)
        self.navController.pushViewController(controller, animated: true)
    }

    func showPrevScreen() {
        navController.popViewController(animated: true)
    }


    func showAlert(title: String, message: String?) {
        DispatchQueue.main.async {
            TextPicker.default.showInfo(showIn: self.navController, title: title, message: message)
        }
    }

}



