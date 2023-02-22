//
//  StoriesItemCell.swift
//  Navigation
//
//  Created by Alex M on 02.02.2023.
//

import SnapKit
import UIKit

protocol StoriesItemCellDelegate: AnyObject {
    func storiesItemPlusButtonDidTap(_ sender: StoriesItemCell)
}

class StoriesItemCell: UICollectionViewCell {
    
    // MARK: - Public
    func configure(with info: FeedStoriesItemCellInfoProtocol) {
        NetworkService.shared.loadPhotoFromUrl (imageUrl: info.image) { image in
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
        plusButton.isHidden = !info.isAddButtonVisible
    }
    
    weak var delegate: StoriesItemCellDelegate?
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private constants
    private enum UIConstants {
        static let imageSize: CGFloat = 60
        static let imageToCellInset: CGFloat = 6
        static let plusButtonSize: CGFloat = 15
    }
    
    // MARK: - Private properties
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = UIConstants.imageSize / 2
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1.0
        view.layer.borderColor = StyleGuide.Colors.orangeColor.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var plusButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "plusButton"), for: .normal)
        button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.fill
        button.contentVerticalAlignment =  UIControl.ContentVerticalAlignment.fill
        let action = UIAction {_ in
            print("plusButton tap")
            self.delegate?.storiesItemPlusButtonDidTap(self)
        }
        button.addAction(action, for: .touchUpInside)
        return button
    }()
    
}

// MARK: - Private methods
private extension StoriesItemCell {
    func initialize() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.size.equalTo(UIConstants.imageSize)
            make.leading.top.trailing.bottom.equalToSuperview().inset(UIConstants.imageToCellInset)
        }
        
        contentView.addSubview(plusButton)
        plusButton.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(imageView)
            make.size.equalTo(UIConstants.plusButtonSize)
        }
    }

}

