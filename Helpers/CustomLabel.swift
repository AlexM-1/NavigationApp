//
//  CustomLabel.swift
//  Navigation
//
//  Created by Alex M on 31.01.2023.
//

import UIKit

class CustomLabel: UILabel {
    
    init(titleColor: UIColor,
         font: UIFont?,
         title: String = "",
         numberOfLines: Int = 1,
         textAlignment: NSTextAlignment = .center,
         lineHeightMultiple: CGFloat = 1.18)
    {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.font = font
        self.numberOfLines = numberOfLines
        setTitle(title: title, lineHeightMultiple: lineHeightMultiple)
        self.textColor = titleColor
        self.textAlignment = textAlignment
        self.isUserInteractionEnabled = true
        
    }
    
    func setTitle(title: String, lineHeightMultiple: CGFloat = 1.18) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        self.attributedText = NSMutableAttributedString(string: title, attributes: [ NSAttributedString.Key.paragraphStyle: paragraphStyle])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        guard previousTraitCollection?.userInterfaceStyle != traitCollection.userInterfaceStyle else { return }

        self.layer.borderColor = StyleGuide.Colors.grey2.cgColor
    }
    
}
