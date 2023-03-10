//
//  OnePostViewController.swift
//  NavigationApp
//
//  Created by Alex M on 03.02.2023.
//


import SnapKit
import UIKit

final class OnePostViewController: UIViewController, UIGestureRecognizerDelegate {
    
    // MARK: - Private constants
    private enum UIConstants {
        static let userImageSize: CGFloat = 30
        static let userImageTopInset: CGFloat = 18
        static let userImageLeadingInset: CGFloat = 29
        static let usernameStackSpacing: CGFloat = 3
        static let usernameStackToProfileImageOffset: CGFloat = 16
        static let postImageViewInset: CGFloat = 16
        static let postImageHeight: CGFloat = 212
        static let postImageToUserImageOffset: CGFloat = 12
        static let topBottomLabelOffset: CGFloat = 15
        static let bottomScrollViewInset: CGFloat = 40
        static let lineWidth: CGFloat = 1
    }
    
    // MARK: - Private properties
    private lazy var navigationBarView = NavigationBarView(title: "Publications".localizable, rigthButtonType: .menu)
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private var bookmarkButtonAction: (() -> Void)?
    private var likeButtonAction: (() -> Void)?
    
    private let lineView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = StyleGuide.Colors.grey2
        return view
    }()
    
    private let userImageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = UIConstants.userImageSize / 2
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private let usernameLabel = CustomLabel(
        titleColor: StyleGuide.Colors.orangeColor,
        font: StyleGuide.Fonts.mediumSize12)
    
    private let professionLabel = CustomLabel(
        titleColor: StyleGuide.Colors.grey2,
        font: StyleGuide.Fonts.regularSize12)
    
    
    private let postImageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private let descriptionLabel = CustomLabel(
        titleColor: StyleGuide.Colors.grey1,
        font: StyleGuide.Fonts.regularSize14,
        title: "",
        numberOfLines: 0,
        textAlignment: .left)
    
    
    private lazy var postFooterView = PostFooterView(frame: .zero)
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: - Public methods
    func configure(post: FeedPostItemInfoProtocol) {
        postFooterView.setLikeButtonTitle(LocalStorage.shared.getLikeCount(post: post))
        postFooterView.setLikeButtonState(isSelected: LocalStorage.shared.getLikeState(post: post))
        postFooterView.setCommentButtonTitle(post.numberOfComments)
        NetworkService.shared.loadPhotoFromUrl (imageUrl: post.userImage) { image in
            DispatchQueue.main.async {
                self.userImageView.image = image
            }
        }
        usernameLabel.text = post.username
        professionLabel.text = post.profession
        descriptionLabel.setTitle(title: post.postText)
        NetworkService.shared.loadPhotoFromUrl (imageUrl: post.postImage.imageUrl) { image in
            DispatchQueue.main.async {
                self.postImageView.image = image
            }
        }
        postFooterView.setBookmarkState(isSelected: post.isAddToBookmarks)
        bookmarkButtonAction =  { CoreDataManager.default.addPost(post: post) }
        likeButtonAction = { LocalStorage.shared.likePost(post: post) }
    }
    
    
    func configure(post: Post) {
        postFooterView.setLikeButtonTitle(Int(post.numberOfLikes))
        postFooterView.setLikeButtonState(isSelected: post.isLiked)
        postFooterView.setCommentButtonTitle(Int(post.numberOfComments))
        NetworkService.shared.loadPhotoFromUrl (imageUrl: post.userImage) { image in
            DispatchQueue.main.async {
                self.userImageView.image = image
            }
        }
        usernameLabel.text = post.username
        professionLabel.text = post.profession
        descriptionLabel.setTitle(title: post.postText ?? "")
        NetworkService.shared.loadPhotoFromUrl (imageUrl: post.postImage) { image in
            DispatchQueue.main.async {
                self.postImageView.image = image
            }
        }
        postFooterView.setBookmarkState(isSelected: post.isAddToBookmarks )
    }
}

// MARK: - Private methods
private extension OnePostViewController {
    
    func initialize() {
        
        view.addSubview(navigationBarView)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationBarView.delegate = self
        postFooterView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        navigationBarView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
        }
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(navigationBarView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.leading.trailing.bottom.top.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
        }
        scrollView.backgroundColor = StyleGuide.Colors.lightBackgroundColor
        
        contentView.addSubview(userImageView)
        userImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(UIConstants.userImageTopInset)
            make.leading.equalToSuperview().inset(UIConstants.userImageLeadingInset)
            make.size.equalTo(UIConstants.userImageSize)
        }
        
        let usernameStack = UIStackView()
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
        
        contentView.addSubview(postImageView)
        postImageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(UIConstants.postImageViewInset)
            make.top.equalTo(usernameStack.snp.bottom).offset(UIConstants.postImageToUserImageOffset)
            make.height.equalTo(UIConstants.postImageHeight)
            
        }
        
        contentView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(UIConstants.postImageViewInset)
            make.top.equalTo(postImageView.snp.bottom).offset(UIConstants.topBottomLabelOffset)
        }
        
        contentView.addSubview(postFooterView)
        postFooterView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(descriptionLabel.snp.bottom).offset(UIConstants.postImageViewInset)
        }
        
        contentView.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(UIConstants.postImageViewInset)
            make.height.equalTo(UIConstants.lineWidth)
            make.top.equalTo(postFooterView.snp.bottom).offset(UIConstants.postImageViewInset)
            make.bottom.equalToSuperview().inset(UIConstants.bottomScrollViewInset)
        }
        
    }
}


// MARK: - NavigationBarViewDelegate

extension OnePostViewController: NavigationBarViewDelegate {
    func leftBarButtonDidTap(_ sender: NavigationBarView) {
        navigationController?.popViewController(animated: true)
    }
    
    func rightBarButtonDidTap(_ sender: NavigationBarView) {
    }
    
}


// MARK: - PostFooterViewDelegate

extension OnePostViewController: PostFooterViewDelegate {
    func likeButtonDidTap(_ sender: PostFooterView) {
        likeButtonAction?()
    }

    func commentButtonDidTap(_ sender: PostFooterView) {
    }

    func bookmarkButtonDidTap(_ sender: PostFooterView) {
        bookmarkButtonAction?()
    }
}
