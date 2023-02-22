//
//  PhotoItemCell.swift
//  NavigationApp
//
//  Created by Alex M on 05.02.2023.
//

import SnapKit
import UIKit

class PhotoItemCell: UICollectionViewCell {

    private var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }

    func setupCell(image: UIImage, cornerRadius: CGFloat) {
        photoImageView.image = image
        photoImageView.layer.cornerRadius = cornerRadius
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func layout() {
        contentView.addSubview(photoImageView)
        photoImageView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }

    }

}
