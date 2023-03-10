//
//  SideMenuTableCell.swift
//  NavigationApp
//
//  Created by Alex M on 17.02.2023.
//

import UIKit
import SnapKit

class SideMenuTableCell: UITableViewCell {

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.tintColor = StyleGuide.Colors.orangeColor
        return imageView
    }()

    private lazy var label = CustomLabel(titleColor: StyleGuide.Colors.grey1,
                                         font: StyleGuide.Fonts.regularSize14,
                                         textAlignment: .left)


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initialize() {
        backgroundColor = StyleGuide.Colors.grey4

        contentView.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(27)
            make.size.equalTo(24)
        }

        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(iconImageView.snp.trailing).offset(14)
        }

    }

    func configure(image: UIImage?,  description: String?) {
        iconImageView.image = image
        label.text = description
    }
}

