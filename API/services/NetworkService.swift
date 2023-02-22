//
//  NetworkService.swift
//  NavigationApp
//
//  Created by Alex M on 10.02.2023.
//

import UIKit

final class NetworkService {
    
    static let shared: NetworkServiceProtocol = {
        
        if let appConfig = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.appConfiguration {
            switch appConfig {
            case .apiManager:
                return ApiManager()
            case .mockData:
                return MockDataManager()
            }
        }
        return MockDataManager()
    }()
    
}
