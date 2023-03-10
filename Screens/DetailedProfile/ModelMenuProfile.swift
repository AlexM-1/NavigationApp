//
//  ModelMenuProfile.swift
//  NavigationApp
//
//  Created by Alex M on 17.02.2023.
//


enum MenuItem {
    case textField(TextFieldItem)
    case buttons(ButtonsItem)
}

struct TextFieldItem {
    enum Style {
        case string
        case date
    }
    var title: String
    var placeholder: String
    var type: Style
    var text: String? = nil
}


struct ButtonsItem {
    let title: String
    let buttonNames: [String]
    let isMale: Bool?
    
}

