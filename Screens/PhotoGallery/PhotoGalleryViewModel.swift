//
//  PhotoGalleryViewModel.swift
//  NavigationApp
//
//  Created by Alex M on 12.02.2023.
//

import UIKit

final class PhotoGalleryViewModel {

    enum Action {
        case photoDidTap(Int)
        case receivedImageFromPicker(UIImage)
    }

    let coordinator: ProfileCoordinator

    var images: [UIImage] {
        switch flow {
        case .userProfile:
            return LocalStorage.shared.mainUserPhotos
        case .postAuthorProfile:
            return LocalStorage.shared.userPhotos
        }
    }
    
    let flow: Flow

    init(coordinator: ProfileCoordinator, flow: Flow) {
        self.coordinator = coordinator
        self.flow = flow
    }

    func changeState(_ action: Action) {
        switch action {

        case .photoDidTap(let index):
            coordinator.showPhotoSlider(flow: flow, index: index)

        case .receivedImageFromPicker(let image):
            LocalStorage.shared.appendPhoto(image: image)

        }
    }

}


