//
//  ButtonsMenuCell.swift
//  NavigationApp
//
//  Created by Alex M on 17.02.2023.
//


import SnapKit
import UIKit


protocol ButtonsMenuCellProtocol {
    func genderIsSelected(_ sender: ButtonsMenuCell, isMale: Bool)
}

class ButtonsMenuCell: UITableViewCell {


    // MARK: - Public
    func configure(item: ButtonsItem) {

        for index in item.buttonNames.indices {
            let button = CustomButton(title: item.buttonNames[index],
                                      titleColor: StyleGuide.Colors.darkTitleColor,
                                      font: StyleGuide.Fonts.regularSize14,
                                      image: UIImage(named: "genderNotSet"),
                                      imageTintColor: StyleGuide.Colors.orangeColor,
                                      imagePadding: 14,
                                      imagePlacement: .leading,
                                      buttonTappedAction: nil)
            button.tag = index
            let action = UIAction {_ in
                self.buttonIsSelected(tag: index)
            }
            button.addAction(action, for: .touchUpInside)

            if item.isMale == true, index == 0 {
                button.setImage(UIImage(named: "genderIsSet"), for: .normal)
            }
            if item.isMale == false, index == 1 {
                button.setImage(UIImage(named: "genderIsSet"), for: .normal)
            }

            buttons.append(button)
        }
        initialize()
    }

    var delegate: ButtonsMenuCellProtocol?

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - Private properties
    private var buttons: [UIButton] = []


    // MARK: - Private method
    private func initialize() {
        selectionStyle = .none
        contentView.backgroundColor = StyleGuide.Colors.lightBackgroundColor
        var height: CGFloat = 0
        buttons.forEach { button in
            self.contentView.addSubview(button)
            button.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(30)
                make.top.equalToSuperview().offset(height)
            }
            height += 30
        }
    }

    private func buttonIsSelected(tag: Int) {
        buttons.forEach { button in
            if button.tag == tag {
                button.setImage(UIImage(named: "genderIsSet"), for: .normal)
            } else {
                button.setImage(UIImage(named: "genderNotSet"), for: .normal)
            }
        }
        delegate?.genderIsSelected(self, isMale: (tag == 0) ? true : false )
    }
}



