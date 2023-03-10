//
//  PostFooterView.swift
//  NavigationApp
//
//  Created by Alex M on 03.02.2023.
//


import SnapKit
import UIKit


protocol PostFooterViewDelegate: AnyObject {
    func likeButtonDidTap(_ sender: PostFooterView)
    func commentButtonDidTap(_ sender: PostFooterView)
    func bookmarkButtonDidTap(_ sender: PostFooterView)
}

class PostFooterView: UIView {
    
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
        static let height: CGFloat = 24
        static let likeButtonLeadingInset: CGFloat = 25
        static let commentButtonLeadingInset: CGFloat = 130
        static let bookmarkButtonTrailingInset: CGFloat = 17
    }
    
    // MARK: - Private properties
    private lazy var likeButtonIsSelected = false
    private lazy var bookmarkButtonIsSelected = false
    private lazy var numberOfLikes = 0
    private lazy var numberOfComments = 0
    
    private lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(StyleGuide.Colors.darkTitleColor, for: .normal)
        button.setTitleColor(StyleGuide.Colors.darkTitleColor, for: .highlighted)
        button.titleLabel?.font = StyleGuide.Fonts.regularSize14 ?? UIFont()
        var configuration = UIButton.Configuration.plain()
        configuration.imagePadding = 10
        button.configuration = configuration
        let action = UIAction {_ in
            self.delegate?.likeButtonDidTap(self)
            if self.likeButtonIsSelected {
                self.numberOfLikes -= 1
            } else {
                self.numberOfLikes += 1
            }
            self.likeButtonIsSelected.toggle()
            self.setLikeButtonState(isSelected: self.likeButtonIsSelected)
            self.setLikeButtonTitle(self.numberOfLikes)
        }
        button.addAction(action, for: .touchUpInside)
        return button
    }()
    
    
    private lazy var commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = StyleGuide.Colors.darkTitleColor
        button.setImage(UIImage(systemName: "bubble.left"), for: .normal)
        button.titleLabel?.font = StyleGuide.Fonts.regularSize14 ?? UIFont()
        var configuration = UIButton.Configuration.plain()
        configuration.imagePadding = 10
        button.configuration = configuration
        let action = UIAction {_ in
            self.delegate?.commentButtonDidTap(self)
        }
        button.addAction(action, for: .touchUpInside)
        return button
    }()
    
    private lazy var bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        let action = UIAction {_ in
            self.delegate?.bookmarkButtonDidTap(self)
            self.bookmarkButtonIsSelected.toggle()
            self.setBookmarkState(isSelected: self.bookmarkButtonIsSelected)
        }
        button.addAction(action, for: .touchUpInside)
        return button
    }()
    
    // MARK: - Public properties
    weak var delegate: PostFooterViewDelegate?
    
    // MARK: - Public methods
    func setLikeButtonTitle(_ numberOfLikes: Int) {
        self.numberOfLikes = numberOfLikes
        self.likeButton.setTitle("\(numberOfLikes.rounded)", for: .normal)
    }
    
    func setLikeButtonState(isSelected: Bool) {
        self.likeButtonIsSelected = isSelected
        if isSelected {
            likeButton.tintColor = StyleGuide.Colors.orangeColor
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            likeButton.tintColor = StyleGuide.Colors.darkTitleColor
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
    
    func setCommentButtonTitle(_ numberOfComments: Int) {
        self.numberOfComments = numberOfComments
        self.commentButton.setTitle("\(numberOfComments.rounded)", for: .normal)
    }
    
    func setBookmarkState(isSelected: Bool) {
        self.bookmarkButtonIsSelected = isSelected
        if isSelected {
            bookmarkButton.tintColor = StyleGuide.Colors.orangeColor
            bookmarkButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        } else {
            bookmarkButton.tintColor = StyleGuide.Colors.darkTitleColor
            bookmarkButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
        }
    }
    
}

// MARK: - Private methods
private extension PostFooterView {
    
    func initialize() {
        
        self.addSubview(likeButton)
        likeButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(UIConstants.likeButtonLeadingInset)
            make.centerY.equalToSuperview()
        }
        
        self.addSubview(commentButton)
        commentButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(UIConstants.commentButtonLeadingInset)
            make.centerY.equalToSuperview()
        }
        
        self.addSubview(bookmarkButton)
        bookmarkButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(UIConstants.bookmarkButtonTrailingInset)
            make.centerY.equalToSuperview()
        }
        
        self.snp.makeConstraints { make in
            make.height.equalTo(UIConstants.height)
        }
    }
}



