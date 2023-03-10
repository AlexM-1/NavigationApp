//
//  FeedPostCell.swift
//  Navigation
//
//  Created by Alex M on 02.02.2023.
//

import SnapKit
import UIKit

class FeedPostCell: UITableViewCell {


    // MARK: - Public
    var showMoreButtonAction: (() -> Void)?
    var likeButtonAction: (() -> Void)?
    var bookmarkButtonAction: (() -> Void)?
    var commentButtonAction: (() -> Void)?
    var showPostAuthorProfileAction: (() -> Void)?


    func configure(with post: FeedPostItemInfoProtocol) {
        NetworkService.shared.loadPhotoFromUrl(imageUrl: post.userImage) { image in
            DispatchQueue.main.async {
                self.userImageView.image = image
            }
        }
        usernameLabel.text = post.username
        professionLabel.text = post.profession
        descriptionLabel.setTitle(title: post.postText)
        NetworkService.shared.loadPhotoFromUrl(imageUrl: post.postImage.imageUrl) { image in
            DispatchQueue.main.async {
                self.postImageView.image = image
            }
        }
        postFooterView.setLikeButtonTitle(LocalStorage.shared.getLikeCount(post: post))
        postFooterView.setLikeButtonState(isSelected: LocalStorage.shared.getLikeState(post: post))
        postFooterView.setCommentButtonTitle(post.numberOfComments)
        postFooterView.setBookmarkState(isSelected: post.isAddToBookmarks)
        postFooterView.delegate = self
    }

    func configure(with post: Post) {
        NetworkService.shared.loadPhotoFromUrl(imageUrl: post.userImage) { image in
            DispatchQueue.main.async {
                self.userImageView.image = image
            }
        }
        usernameLabel.text = post.username
        professionLabel.text = post.profession

        if let text = post.postText {
            descriptionLabel.setTitle(title: text)
        }
        NetworkService.shared.loadPhotoFromUrl(imageUrl: post.postImage) { image in
            DispatchQueue.main.async {
                self.postImageView.image = image
            }
        }
        postFooterView.setLikeButtonTitle(Int(post.numberOfLikes))
        postFooterView.setLikeButtonState(isSelected: post.isLiked)
        postFooterView.setCommentButtonTitle(Int(post.numberOfComments))
        postFooterView.setBookmarkState(isSelected: post.isAddToBookmarks)
        postFooterView.delegate = self
    }

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
        setupGesture()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        userImageView.image = nil
        usernameLabel.text = nil
        professionLabel.text = nil
        descriptionLabel.setTitle(title: "")
        postImageView.image = nil
        postFooterView.setLikeButtonTitle(0)
        postFooterView.setLikeButtonState(isSelected: false)
        postFooterView.setCommentButtonTitle(0)
        postFooterView.setBookmarkState(isSelected: false)
    }

    // MARK: - Private constants
    private enum UIConstants {
        static let userImageSize: CGFloat = 60
        static let contentInset: CGFloat = 16
        static let userImageTopInset: CGFloat = 25
        static let usernameStackToProfileImageOffset: CGFloat = 24
        static let optionsButtonTopOffset: CGFloat = 36
        static let usernameStackSpacing: CGFloat = 8
        static let postImageToUserImageOffset: CGFloat = 12

    }

    // MARK: - Private properties
    private let mainView: UIView = {
        let view = UIView()
        view.backgroundColor = StyleGuide.Colors.grey4
        let verticalLineView = UIView(frame: CGRect(x: 28, y: 20, width: 1, height: 219))
        verticalLineView.backgroundColor = StyleGuide.Colors.grey1
        view.addSubview(verticalLineView)
        let horizontallLineView = UIView(frame: CGRect(x: 0, y: 260, width: UIScreen.main.bounds.width, height: 0.5))
        horizontallLineView.backgroundColor = StyleGuide.Colors.grey2
        view.addSubview(horizontallLineView)
        return view
    }()

    private let userImageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = UIConstants.userImageSize / 2
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        view.isUserInteractionEnabled = true
        return view
    }()

    private let usernameLabel = CustomLabel(
        titleColor: StyleGuide.Colors.darkTitleColor,
        font: StyleGuide.Fonts.mediumSize16)

    private let professionLabel = CustomLabel(
        titleColor: StyleGuide.Colors.grey2,
        font: StyleGuide.Fonts.regularSize14)

    private lazy var optionsButton = ButtonWithMenuItems()

    private let usernameStack = UIStackView()

    private let postImageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()

    private lazy var postFooterView = PostFooterView(frame: .zero)

    private let descriptionLabel = CustomLabel(
        titleColor: StyleGuide.Colors.grey1,
        font: StyleGuide.Fonts.regularSize14,
        title: "",
        numberOfLines: 4,
        textAlignment: .left)

    private lazy var showMoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = StyleGuide.Colors.blue
        button.setTitle("Show in full...".localizable, for: .normal)
        let action = UIAction {_ in
            self.showMoreButtonAction?()
        }
        button.addAction(action, for: .touchUpInside)
        return button
    }()
}

// MARK: - Private methods
private extension FeedPostCell {

    func initialize() {
        selectionStyle = .none
        contentView.backgroundColor = StyleGuide.Colors.lightBackgroundColor
        contentView.addSubview(userImageView)
        userImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(UIConstants.contentInset)
            make.top.equalToSuperview().inset(UIConstants.userImageTopInset)
            make.size.equalTo(UIConstants.userImageSize)
        }


        usernameStack.axis = .vertical
        usernameStack.alignment = .leading
        usernameStack.spacing = UIConstants.usernameStackSpacing
        usernameStack.addArrangedSubview(usernameLabel)
        usernameStack.addArrangedSubview(professionLabel)
        contentView.addSubview(usernameStack)
        usernameStack.snp.makeConstraints { make in
            make.centerY.equalTo(userImageView)
            make.leading.equalTo(userImageView.snp.trailing).offset(UIConstants.usernameStackToProfileImageOffset)
        }
        contentView.addSubview(optionsButton)
        optionsButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(UIConstants.optionsButtonTopOffset)
            make.trailing.equalToSuperview().inset(UIConstants.contentInset)
        }

        contentView.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(userImageView.snp.bottom).offset(UIConstants.postImageToUserImageOffset)
            make.bottom.equalToSuperview().inset(10)
        }


        mainView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(52)
            make.trailing.equalToSuperview().inset(23)
            make.top.equalToSuperview().offset(10)
        }

        mainView.addSubview(showMoreButton)
        showMoreButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(52)
            make.top.equalTo(descriptionLabel.snp.bottom)

        }
        mainView.addSubview(postImageView)
        postImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(52)
            make.trailing.equalToSuperview().inset(23)
            make.top.equalTo(showMoreButton.snp.bottom).offset(5)
            make.height.equalTo(125)
        }

        mainView.addSubview(postFooterView)
        postFooterView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(postImageView.snp.bottom).offset(17)
        }
    }

    func setupGesture() {
        let labelGR = UITapGestureRecognizer(target: self, action: #selector(descriptionLabelDidTap))
        descriptionLabel.addGestureRecognizer(labelGR)
        let userImageViewGR = UITapGestureRecognizer(target: self, action: #selector(showUserInfoDidTap))
        let usernameStackGR = UITapGestureRecognizer(target: self, action: #selector(showUserInfoDidTap))
        userImageView.addGestureRecognizer(userImageViewGR)
        usernameStack.addGestureRecognizer(usernameStackGR)
    }

    @objc func descriptionLabelDidTap() {
        self.showMoreButtonAction?()
    }

    @objc func showUserInfoDidTap() {
        self.showPostAuthorProfileAction?()
    }

}

// MARK: - PostFooterViewDelegate
extension FeedPostCell: PostFooterViewDelegate {
    func likeButtonDidTap(_ sender: PostFooterView) {
        self.likeButtonAction?()
        
    }

    func commentButtonDidTap(_ sender: PostFooterView) {
        self.commentButtonAction?()
    }

    func bookmarkButtonDidTap(_ sender: PostFooterView) {
        self.bookmarkButtonAction?()
    }
}

