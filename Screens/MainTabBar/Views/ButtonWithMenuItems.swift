//
//  ButtonWithMenuItems.swift
//  NavigationApp
//
//  Created by Alex M on 03.02.2023.
//


import UIKit
    
class ButtonWithMenuItems: UIButton {
    
    init() {
        super.init(frame: .zero)
        self.setImage(UIImage(named: "ellipsis"), for: .normal)
        self.tintColor = StyleGuide.Colors.orangeColor
        
        let menuItems: [UIAction] =
        [
            UIAction(title: "Сохранить в закладках", image: nil) { _ in
                print("Сохранить в закладках")
            },
            UIAction(title: "Закрепить", image: nil) {_ in
                print("Закрепить")
            },
            UIAction(title: "Выключить комментирование", image: nil) {_ in
                print("Выключить комментирование")
            },
            UIAction(title: "Скопировать ссылку", image: nil) {_ in
                print("Скопировать ссылку")
            },
            UIAction(title: "Архивировать запись", image: nil) {_ in
                print("Архивировать запись")
            },
            UIAction(title: "Удалить", image: nil) {_ in
                print("Удалить")
            },
        ]
        
        let menu = UIMenu(title: "Выберите действие", image: nil, identifier: nil, options: [], children: menuItems)
        
        self.menu = menu
        self.showsMenuAsPrimaryAction = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
