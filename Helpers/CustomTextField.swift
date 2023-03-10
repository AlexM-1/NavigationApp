//
//  CustomTextField.swift
//  Navigation
//
//  Created by Alex M on 01.02.2023.
//

import UIKit

class CustomTextField: UITextField {

    init(placeholder: String)
    {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.textColor = StyleGuide.Colors.grey2
        self.backgroundColor = StyleGuide.Colors.lightBackgroundColor
        self.font = StyleGuide.Fonts.mediumSize16
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1
        self.layer.borderColor = StyleGuide.Colors.grey1.cgColor
        self.placeholder = placeholder
        self.textAlignment = .center
        self.keyboardType = .numberPad
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        guard previousTraitCollection?.userInterfaceStyle != traitCollection.userInterfaceStyle else { return }

        self.layer.borderColor = StyleGuide.Colors.grey1.cgColor
    }

}

