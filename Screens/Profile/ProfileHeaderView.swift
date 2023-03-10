//
//  ProfileView.swift
//  NavigationApp
//
//  Created by Alex M on 05.02.2023.
//


import SnapKit
import UIKit

protocol ProfileHeaderViewDelegate: AnyObject {
    func editButtonDidTap(_ sender: ProfileHeaderView)
    func detailedInformationButtonDidTap(_ sender: ProfileHeaderView)
    func noteButtonDidTap(_ sender: ProfileHeaderView)
    func historyButtonDidTap(_ sender: ProfileHeaderView)
    func photoButtonDidTap(_ sender: ProfileHeaderView)
    func messageButtonDidTap(_ sender: ProfileHeaderView)
    func callButtonDidTap(_ sender: ProfileHeaderView)
}

class ProfileHeaderView: UIView {

    // MARK: - Init

    init(user: UserProfileInfo,
         flow: Flow) {
        self.user = user
        self.flow = flow
        super.init(frame: .zero)
        configure()
        initialize()
        setupGesture()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public properties

    weak var delegate: ProfileHeaderViewDelegate?

    // MARK: - Private constants

    private enum UIConstants {
        static let userImageSize: CGFloat = 60
    }

    // MARK: - Private properties

    private var user: UserProfileInfo
    private var flow: Flow


    private let tapGestureRecognizer = UITapGestureRecognizer()

    private lazy var transparentView: UIView = {
        let view = UIView()
        view.alpha = 0.0
        view.backgroundColor = .black
        return view
    }()

    private let lineSpacerView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = StyleGuide.Colors.grey3
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
        titleColor: StyleGuide.Colors.grey1,
        font: StyleGuide.Fonts.semiBoldSize18)

    private let professionLabel = CustomLabel(
        titleColor: StyleGuide.Colors.grey2,
        font: StyleGuide.Fonts.regularSize12)


    private lazy var editButton = CustomButton(
        title: "Edit".localizable,
        titleColor: StyleGuide.Colors.lightTitleColor,
        font: StyleGuide.Fonts.mediumSize16,
        backgroundColor: StyleGuide.Colors.orangeColor) {
            self.delegate?.editButtonDidTap(self)
        }

    private lazy var detailedInformationButton = CustomButton(
        title: "Detailed information".localizable,
        titleColor: StyleGuide.Colors.grey1,
        font: StyleGuide.Fonts.mediumSize14,
        backgroundColor: StyleGuide.Colors.lightBackgroundColor,
        image: UIImage(systemName: "exclamationmark.circle.fill"),
        imageTintColor: StyleGuide.Colors.orangeColor,
        imagePadding: 8) {
            self.delegate?.detailedInformationButtonDidTap(self)
        }

    private let publicationsLabel = CustomLabel(
        titleColor: StyleGuide.Colors.darkTitleColor,
        font: StyleGuide.Fonts.regularSize14,
        numberOfLines: 2)

    private let subscriptionsLabel = CustomLabel(
        titleColor: StyleGuide.Colors.darkTitleColor,
        font: StyleGuide.Fonts.regularSize14,
        numberOfLines: 2)

    private let subscribersLabel = CustomLabel(
        titleColor: StyleGuide.Colors.darkTitleColor,
        font: StyleGuide.Fonts.regularSize14,
        numberOfLines: 2)

    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.configuration = .gray()
        button.tintColor = StyleGuide.Colors.orangeColor
        button.alpha = 0.0
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.addTarget(self, action: #selector(closeButtonTap), for: .touchUpInside)
        return button
    }()

    private lazy var actionsHorizStack: UIStackView = {
        let actionsHorizStack = UIStackView()
        actionsHorizStack.axis = .horizontal
        actionsHorizStack.alignment = .center
        actionsHorizStack.spacing = 0
        actionsHorizStack.distribution = .fillEqually
        actionsHorizStack.contentMode = .center

        let noteButton = CustomButton(title: "Note".localizable,
                                      titleColor: StyleGuide.Colors.grey1,
                                      font: StyleGuide.Fonts.regularSize14,
                                      image: UIImage(named: "noteIcon"),
                                      imagePadding: 10,
                                      imagePlacement: .top) {
            print("noteButton tapped")
            self.delegate?.noteButtonDidTap(self)
        }

        let historyButton = CustomButton(title: "History".localizable,
                                         titleColor: StyleGuide.Colors.grey1,
                                         font: StyleGuide.Fonts.regularSize14,
                                         image: UIImage(named: "cameraIcon"),
                                         imagePadding: 10,
                                         imagePlacement: .top) {
            print("historyButton tapped")
            self.delegate?.historyButtonDidTap(self)
        }

        let photoButton = CustomButton(title: "Photo".localizable,
                                       titleColor: StyleGuide.Colors.grey1,
                                       font: StyleGuide.Fonts.regularSize14,
                                       image: UIImage(named: "imageIcon"),
                                       imagePadding: 10,
                                       imagePlacement: .top) {
            print("photoButton tapped")
            self.delegate?.photoButtonDidTap(self)
        }

        actionsHorizStack.addArrangedSubview(noteButton)
        actionsHorizStack.addArrangedSubview(historyButton)
        actionsHorizStack.addArrangedSubview(photoButton)
        return actionsHorizStack
    }()

    private lazy var messageButton = CustomButton(
        title: "message".localizable,
        titleColor: StyleGuide.Colors.lightTitleColor,
        font: StyleGuide.Fonts.mediumSize14,
        backgroundColor: StyleGuide.Colors.grey1) {
            self.delegate?.messageButtonDidTap(self)
        }


    private lazy var callButton = CustomButton(
        title: "call".localizable,
        titleColor: StyleGuide.Colors.lightTitleColor,
        font: StyleGuide.Fonts.mediumSize14,
        backgroundColor: StyleGuide.Colors.grey5) {
            self.delegate?.callButtonDidTap(self)
        }

}

// MARK: - Private methods

private extension ProfileHeaderView {

    func configure() {
        NetworkService.shared.loadPhotoFromUrl(imageUrl: user.userImage) { image in
            DispatchQueue.main.async {
                self.userImageView.image = image
            }
        }
        usernameLabel.text = [ user.name, user.surname].compactMap { $0 }.joined(separator: " ")
        professionLabel.text = user.profession

        publicationsLabel.text = getPluralDescription(value: user.publications, format: "any_posts".localizable)

        subscriptionsLabel.text = getPluralDescription(value: user.subscriptions, format: "any_subscriptions".localizable)


        subscribersLabel.text = getPluralDescription(value: user.subscribers, format: "any_subscribers".localizable)

    }

    func getPluralDescription(value: Int, format: String) -> String {
        let result = "\(String(describing: value.roundedWithAbbreviations)) \n"
        if value >= 1_000_000 {
            return result + String(format: format, value / 1_000_000 * 1_000_000)
        }
        if value >= 1_000 {
            return result + String(format: format, value / 1_000 * 1_000)
        }
        return result + String(format: format, value)
    }

    func initialize() {

        self.backgroundColor = StyleGuide.Colors.lightBackgroundColor

        self.addSubview(userImageView)
        userImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(26)
            make.top.equalToSuperview()
            make.size.equalTo(UIConstants.userImageSize)
        }

        let usernameStack = UIStackView()
        usernameStack.axis = .vertical
        usernameStack.alignment = .leading
        usernameStack.spacing = 3
        usernameStack.addArrangedSubview(usernameLabel)
        usernameStack.addArrangedSubview(professionLabel)
        self.addSubview(usernameStack)

        usernameStack.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(96)
        }

        self.addSubview(detailedInformationButton)
        detailedInformationButton.snp.makeConstraints { make in
            make.top.equalTo(usernameStack.snp.bottom).offset(5)
            make.leading.equalTo(usernameStack.snp.leading)
        }

        let counterHorizStack = UIStackView()
        counterHorizStack.axis = .horizontal
        counterHorizStack.alignment = .center
        counterHorizStack.spacing = 0
        counterHorizStack.distribution = .fillEqually
        counterHorizStack.contentMode = .center
        counterHorizStack.addArrangedSubview(publicationsLabel)
        counterHorizStack.addArrangedSubview(subscriptionsLabel)
        counterHorizStack.addArrangedSubview(subscribersLabel)

        self.addSubview(counterHorizStack)
        counterHorizStack.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(160)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(60)
        }

        switch flow {
        case .userProfile:
            self.addSubview(editButton)
            editButton.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(98)
                make.centerX.equalToSuperview()
                make.height.equalTo(47)
                make.width.equalTo(344)
            }

            self.addSubview(actionsHorizStack)
            actionsHorizStack.snp.makeConstraints { make in
                make.top.equalTo(counterHorizStack.snp.bottom).offset(16)
                make.leading.trailing.equalToSuperview().inset(16)
                make.height.equalTo(68)
            }

        case .postAuthorProfile:
            self.addSubview(messageButton)
            messageButton.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(98)
                make.centerX.equalToSuperview().offset(-92)
                make.height.equalTo(47)
                make.width.equalTo(160)
            }
            self.addSubview(callButton)
            callButton.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(98)
                make.centerX.equalToSuperview().offset(92)
                make.height.equalTo(47)
                make.width.equalTo(160)
            }
        }


        self.addSubview(lineSpacerView)
        lineSpacerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(230)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(0.5)
        }


        self.addSubview(transparentView)
        transparentView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.width)
            make.height.equalTo(UIScreen.main.bounds.height)
        }

        self.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.width.height.equalTo(27)
        }
    }


    func setupGesture() {
        tapGestureRecognizer.addTarget(self, action: #selector(handleTapGesture))
        userImageView.addGestureRecognizer(tapGestureRecognizer)
    }


    @objc func closeButtonTap() {
        UIView.animate(withDuration: 0.3, delay: 0) {
            self.closeButton.alpha = 0.0
            self.layoutIfNeeded()
        } completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 0) {
                self.userImageView.snp.updateConstraints { (make) in
                    make.leading.equalToSuperview().offset(16)
                    make.top.equalToSuperview().offset(16)
                    make.width.height.equalTo(UIConstants.userImageSize)
                }
                self.userImageView.layer.cornerRadius = UIConstants.userImageSize / 2
                self.transparentView.alpha = 0.0
                self.layoutIfNeeded()
            }
        }
    }

    @objc func handleTapGesture(_ gestureRecognizer: UITapGestureRecognizer) {
        guard tapGestureRecognizer === gestureRecognizer else { return }
        UIView.animate(withDuration: 0.5, delay: 0) {
            self.userImageView.snp.updateConstraints { (make) in
                make.leading.equalToSuperview()
                make.top.equalToSuperview().offset(50)
                make.width.height.equalTo(UIScreen.main.bounds.width)
            }
            self.userImageView.layer.cornerRadius = 0
            self.bringSubviewToFront(self.userImageView)
            
            self.transparentView.alpha = 0.7
            self.layoutIfNeeded()
        }   completion: { _ in
            UIView.animate(withDuration: 0.3, delay: 0) {
                self.closeButton.alpha = 1.0
                self.layoutIfNeeded()
            }
        }
    }

}




