//
//  AppCoordinator.swift
//  Navigation
//
//  Created by Alex M on 01.02.2023.
//


import UIKit

final class AppCoordinator {
    
    private var navController: UINavigationController
    private var viewModel: AuthViewModel!
    
    
    init(navController: UINavigationController) {
        self.navController = navController
    }
    
    
    func startApplication() {
        viewModel = AuthViewModel(coordinator: self)
        let controller = StartScreen(viewModel: viewModel)
        navController.setViewControllers([controller], animated: true)
//        LocalStorage.shared.mainUser = MockModel.shared.testUser
//        showMainTabBar()
    }
    
    
    func showRegistrationScreen() {
        let controller = RegistrationScreen(viewModel: viewModel)
        self.navController.pushViewController(controller, animated: true)
    }
    
    func showLoginScreen() {
        let controller = LoginScreen(viewModel: viewModel)
        self.navController.pushViewController(controller, animated: true)
    }
    
    
    func showPrevScreen() {
        navController.popViewController(animated: true)
    }
    
    func showMainTabBar() {
        let controller = MainTabBarViewController()
        navController.isNavigationBarHidden = true
        navController.setViewControllers([controller], animated: true)
    }
    
    
    func showConfirmRegistrationScreen() {
        let controller = ConfirmRegistrationScreen(viewModel: viewModel)
        self.navController.pushViewController(controller, animated: true)
    }
    
    
    func showAlert(title: String, message: String?) {
        DispatchQueue.main.async {
            TextPicker.default.showInfo(showIn: self.navController, title: title, message: message)
        }
    }
    
}
