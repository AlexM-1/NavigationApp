//
//  RegistrationScreen.swift
//  Navigation
//
//  Created by Alex M on 01.02.2023.
//

import SnapKit
import UIKit

final class RegistrationScreen: UIViewController {

    // MARK: - Private properties

    private let viewModel: AuthViewModel

    private let scrollView = UIScrollView()

    private let mainLabel = CustomLabel(
        titleColor: StyleGuide.Colors.grey1,
        font: StyleGuide.Fonts.semiBoldSize18,
        title: "REGISTER".localizable)

    private let secondaryLabel = CustomLabel(
        titleColor: StyleGuide.Colors.grey3,
        font: StyleGuide.Fonts.mediumSize16,
        title: "Enter the number".localizable)

    private let additionalLabel = CustomLabel(
        titleColor: StyleGuide.Colors.grey2,
        font: StyleGuide.Fonts.mediumSize12,
        title: "Your number will be used \n to log in to your account".localizable,
        numberOfLines: 2)

    private lazy var phoneNumberTextField = CustomTextField(
        placeholder: "+7 _ _ _ - _ _ _ - _ _ - _ _")


    private lazy var nextButton = CustomButton(
        title: "NEXT".localizable,
        titleColor: StyleGuide.Colors.lightTitleColor,
        font: StyleGuide.Fonts.mediumSize16,
        backgroundColor: StyleGuide.Colors.darkBackgroundColor) {
            let phoneNumber = self.phoneNumberTextField.text ?? ""
            self.viewModel.changeState(.nextButtonTap(phoneNumber))
        }

    private let privacyPolicyLabel = CustomLabel(
        titleColor: StyleGuide.Colors.grey2,
        font: StyleGuide.Fonts.mediumSize12,
        title: "By clicking the “Next” button You accept the User Agreement and Privacy Policy".localizable,
        numberOfLines: 0)



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
        setTapToHideKB()
    }

}




// MARK: - Private methods

private extension RegistrationScreen {

    private func setupView() {

        phoneNumberTextField.delegate = self
        nextButton.isEnabled = false
        scrollView.showsVerticalScrollIndicator = false

        view.backgroundColor = StyleGuide.Colors.lightBackgroundColor

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "arrowBack"), style: .plain, target: self, action: #selector(backButtonTap))
        self.navigationItem.leftBarButtonItem?.tintColor = StyleGuide.Colors.darkTitleColor

        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        scrollView.addSubview(mainLabel)
        mainLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(104)
        }

        scrollView.addSubview(secondaryLabel)
        secondaryLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(mainLabel.snp.bottom).offset(70)
        }

        scrollView.addSubview(additionalLabel)
        additionalLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(secondaryLabel.snp.bottom).offset(5)
        }

        scrollView.addSubview(phoneNumberTextField)
        phoneNumberTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(additionalLabel.snp.bottom).offset(23)
            make.height.equalTo(48)
            make.width.equalTo(260)
        }

        scrollView.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(phoneNumberTextField.snp.bottom).offset(63)
            make.height.equalTo(47)
            make.width.equalTo(120)
        }

        scrollView.addSubview(privacyPolicyLabel)
        privacyPolicyLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(nextButton.snp.bottom).offset(20)
            make.width.equalTo(260)
            make.bottom.equalToSuperview().inset(50)
        }


    }

    private func setTapToHideKB() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }



    @objc func backButtonTap() {
        viewModel.changeState(.backButtonTap)
    }

}


// MARK: - TextFieldDelegate

extension RegistrationScreen: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        guard let text = textField.text else { return false }
        let mask = "+#-###-###-##-##"
        let newString = (text as NSString).replacingCharacters(in: range, with: string)
        textField.text = Formatter.getFormattedNumber(from: newString, withMask: mask)
        nextButton.isEnabled = (textField.text?.count == mask.count) ? true : false
        return false
    }
}
