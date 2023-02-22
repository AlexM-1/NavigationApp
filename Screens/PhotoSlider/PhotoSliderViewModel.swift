//
//  PhotoSliderViewModel.swift
//  NavigationApp
//
//  Created by Alex M on 15.02.2023.
//

import UIKit

final class PhotoSliderViewModel {

    enum Action {
        case trashButtonDidTap(Int)
    }
    
    enum State {
        case initial
        case update(String, Int)
    }
    
    var images: [UIImage] {
        switch flow {
        case .userProfile:
            return LocalStorage.shared.mainUserPhotos
        case .postAuthorProfile:
            return LocalStorage.shared.userPhotos
        }
    }
    let flow: Flow
    
    var stateChanged: ((State) -> Void)?
    private(set) var state: State = .initial {
        didSet {
            stateChanged?(state)
        }
    }


    init(flow: Flow) {
        self.flow = flow
    }
    
    func changeState(_ action: Action) {
        switch action {
            
        case .trashButtonDidTap(var index):
            LocalStorage.shared.deletePhoto(index: index)
            // если удалено последнее фото сдвигаем указатель на предыдущее фото
            if index == images.count && index > 0 {
                index -= 1
            }
            // меняем title в контроллере
            var title = ""
            if images.isEmpty {
                title = "Пусто"
            } else {
                title = "\(index + 1) из \(images.count)"
            }
            state = .update(title, index)
        }
    }
}



