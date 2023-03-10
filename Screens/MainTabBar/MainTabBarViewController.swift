//
//  MainTabBarViewController2.swift
//  Navigation
//
//  Created by Alex M on 02.02.2023.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    private let feedViewController = Factory(flow: .feed)
    private let profileViewController = Factory(flow: .profile)
    private let favoriteViewController = Factory(flow: .favorite)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setControllers()
        setupTabBar()
    }

    private func setControllers() {
        viewControllers = [
            feedViewController.navigationController,
            profileViewController.navigationController,
            favoriteViewController.navigationController
        ]
    }

    private func setupTabBar() {

        tabBar.tintColor = StyleGuide.Colors.orangeColor
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()

        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        tabBar.standardAppearance = tabBarAppearance

    }

}

