//
//  ProfileScrollPhotoCell.swift
//  NavigationApp
//
//  Created by Alex M on 05.02.2023.
//

import SnapKit
import UIKit

protocol ProfileScrollPhotoCellDelegate: AnyObject {
    func photoCellDidTap(_ sender: ProfileScrollPhotoCell, index: Int)
    func arrowForwardButtonDidTap(_ sender: ProfileScrollPhotoCell)
}

class ProfileScrollPhotoCell: UITableViewCell {

    // MARK: - Public
    weak var delegate: ProfileScrollPhotoCellDelegate?

    func configure(with images: [UIImage]) {
        self.images = images
        collectionView.reloadData()
        photoCountLabel.text = "\(images.count)"
    }

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private constants
    private enum UIConstants {
        static let cellWidth: CGFloat = 72
        static let cellHeight: CGFloat = 66
        static let sideInset: CGFloat = 16
        static let minimumLineSpacingForSectionAt: CGFloat = 4
        static let labelToCollectionOffset: CGFloat = 29
        static let interLabelInset: CGFloat = 10
        static let arrowHeight: CGFloat = 24
    }

    // MARK: - Private properties
    private var collectionView: UICollectionView!
    private var images: [UIImage] = []

    private let contentMainView = UIView()

    private lazy var photoLabel = CustomLabel(
        titleColor: StyleGuide.Colors.darkTitleColor,
        font: StyleGuide.Fonts.mediumSize16,
        title: "Photos".localizable)

    private lazy var photoCountLabel = CustomLabel(
        titleColor: StyleGuide.Colors.grey1,
        font: StyleGuide.Fonts.mediumSize16,
        title: "0")


    private lazy var arrowForwardButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "chevron.forward"), for: .normal)
        button.imageView?.tintColor = StyleGuide.Colors.darkTitleColor
        button.addTarget(self, action: #selector(arrowForwardButtonDidTap), for: .touchUpInside)
        return button
    }()
}

// MARK: - Private methods
private extension ProfileScrollPhotoCell {

    func initialize() {
        contentView.addSubview(contentMainView)
        contentMainView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PhotoItemCell.self, forCellWithReuseIdentifier: String(describing: PhotoItemCell.self))
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        contentMainView.backgroundColor = StyleGuide.Colors.lightBackgroundColor

        contentMainView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(UIConstants.labelToCollectionOffset)
        }

        contentMainView.addSubview(photoLabel)
        photoLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().inset(UIConstants.sideInset)

        }

        contentMainView.addSubview(photoCountLabel)
        photoCountLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(photoLabel.snp.trailing).offset(UIConstants.interLabelInset)
        }

        contentMainView.addSubview(arrowForwardButton)
        arrowForwardButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview().inset(UIConstants.sideInset)
        }
    }


    @objc func arrowForwardButtonDidTap() {
        delegate?.arrowForwardButtonDidTap(self)
    }
}

// MARK: - UICollectionViewDataSource
extension ProfileScrollPhotoCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PhotoItemCell.self), for: indexPath) as! PhotoItemCell
        cell.setupCell(image: images[indexPath.item], cornerRadius: 5)
        return cell
    }
}


// MARK: - UIScrollViewDelegate
extension ProfileScrollPhotoCell: UIScrollViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.photoCellDidTap(self, index: indexPath.item)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ProfileScrollPhotoCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: UIConstants.cellWidth, height: UIConstants.cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        UIConstants.minimumLineSpacingForSectionAt
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        let sideInset = UIConstants.sideInset
        return UIEdgeInsets(top: 0, left: sideInset, bottom: 0, right: sideInset)
    }
}


