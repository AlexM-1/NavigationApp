//
//  TextFieldMenuCell.swift
//  NavigationApp
//
//  Created by Alex M on 17.02.2023.
//


import SnapKit
import UIKit

class TextFieldMenuCell: UITableViewCell {


    // MARK: - Public
    func configure(item: TextFieldItem, tag: Int) {
        textField.text = item.text
        textField.placeholder = item.placeholder
        textField.tag = tag
        textField.delegate = delegate
        switch item.type {
        case .string:
            textField.keyboardType = .default
        case .date:
            textField.keyboardType = .numberPad
        }
    }

    var delegate: UITextFieldDelegate?


    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - Private properties
    private lazy var textField: UITextField = {
        let textField =  UITextField()
        textField.textColor = StyleGuide.Colors.darkTitleColor
        textField.backgroundColor = StyleGuide.Colors.grey4
        textField.font = StyleGuide.Fonts.mediumSize14
        textField.layer.cornerRadius = 8
        textField.textAlignment = .left
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: textField.frame.size.height))
        leftView.backgroundColor = textField.backgroundColor
        textField.leftView = leftView
        textField.leftViewMode = UITextField.ViewMode.always
        return textField
    }()


    private func initialize() {
        selectionStyle = .none
        contentView.backgroundColor = StyleGuide.Colors.lightBackgroundColor
        textField.delegate = delegate
        contentView.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.width.equalTo(336)
            make.height.equalTo(40)
        }
    }
}


