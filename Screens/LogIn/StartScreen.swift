//
//  StartScreen.swift
//  Navigation
//
//  Created by Alex M on 30.01.2023.
//

import SnapKit
import UIKit

final class StartScreen: UIViewController {

    // MARK: - Private properties

    private let viewModel: AuthViewModel

    private let scrollView = UIScrollView()

    private lazy var onBoardingImage: UIImageView = {
        let view = UIImageView(image: UIImage(named: "onBoardingImage"))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var registerButton = CustomButton (
        title: "REGISTER".localizable,
        titleColor: StyleGuide.Colors.lightTitleColor,
        font: StyleGuide.Fonts.mediumSize16,
        backgroundColor: StyleGuide.Colors.darkBackgroundColor) {
            self.viewModel.changeState(.registerAccountButtonTap)
        }

    private lazy var haveAccountButton = CustomButton(
        title: "Already have an account".localizable,
        titleColor: StyleGuide.Colors.darkTitleColor,
        font: StyleGuide.Fonts.regularSize14,
        backgroundColor: StyleGuide.Colors.lightBackgroundColor) {
            self.viewModel.changeState(.haveAccountButtonTap)
        }


    // MARK: - Private constants

    private enum UIConstants {

        static let imageSize: CGFloat = 344
        static let imageTopInset: CGFloat = 80
        static let registerButtonToImageOffset: CGFloat = 80
        static let buttonHeight: CGFloat = 48
        static let buttonWidth: CGFloat = 260
        static let haveAccountButtonToRegisterButtonOffset: CGFloat = 16
        static let bottomInset: CGFloat = 50
    }


    // MARK: - View lifecycle

    init(viewModel: AuthViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

}

// MARK: - Private methods

private extension StartScreen {

    private func setupView() {

        view.backgroundColor = StyleGuide.Colors.lightBackgroundColor
        scrollView.showsVerticalScrollIndicator = false

        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        scrollView.addSubview(onBoardingImage)
        onBoardingImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(UIConstants.imageTopInset)
            make.size.equalTo(UIConstants.imageSize)
        }

        scrollView.addSubview(registerButton)
        registerButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(onBoardingImage.snp.bottom).offset(UIConstants.registerButtonToImageOffset)
            make.height.equalTo(UIConstants.buttonHeight)
            make.width.equalTo(UIConstants.buttonWidth)
        }

        scrollView.addSubview(haveAccountButton)
        haveAccountButton.snp.makeConstraints { make in
            make.top.equalTo(registerButton.snp.bottom).offset(UIConstants.haveAccountButtonToRegisterButtonOffset)
            make.trailing.leading.height.equalTo(registerButton)

            make.bottom.equalToSuperview().inset(UIConstants.bottomInset)

        }

    }

}

