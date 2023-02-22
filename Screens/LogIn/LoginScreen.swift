//
//  LoginScreen.swift
//  Navigation
//
//  Created by Alex M on 31.01.2023.
//

import SnapKit
import UIKit

final class LoginScreen: UIViewController {
    
    // MARK: - Private properties
    
    private let viewModel: AuthViewModel
    
    private let scrollView = UIScrollView()
    
    private let mainLabel = CustomLabel(
        titleColor: StyleGuide.Colors.orangeColor,
        font: StyleGuide.Fonts.semiBoldSize18,
        title: "Welcome back".localizable)
    
    private let secondaryLabel = CustomLabel(
        titleColor: StyleGuide.Colors.grey1,
        font: StyleGuide.Fonts.regularSize14,
        title: "Enter the phone number \n to log in to the app".localizable,
        numberOfLines: 2)
    
    
    private lazy var phoneNumberTextField = CustomTextField(
        placeholder: "+7 _ _ _ - _ _ _ - _ _ - _ _")
    
    
    private lazy var confirmButton = CustomButton(
        title: "CONFIRM".localizable,
        titleColor: StyleGuide.Colors.lightTitleColor,
        font: StyleGuide.Fonts.mediumSize16,
        backgroundColor: StyleGuide.Colors.darkBackgroundColor) {
            let phoneNumber = self.phoneNumberTextField.text ?? ""
            self.viewModel.changeState(.confirmNumberButtonTap(phoneNumber))
        }
    
    
    // MARK: - Init, View lifecycle
    
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

private extension LoginScreen {
    
    private func setupView() {
        
        phoneNumberTextField.delegate = self
        confirmButton.isEnabled = false
        
        view.backgroundColor = StyleGuide.Colors.lightBackgroundColor
        scrollView.showsVerticalScrollIndicator = false
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "arrowBack"), style: .plain, target: self, action: #selector(backButtonTap))
        self.navigationItem.leftBarButtonItem?.tintColor = StyleGuide.Colors.darkTitleColor
        
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        
        scrollView.addSubview(mainLabel)
        mainLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(180)
        }
        
        scrollView.addSubview(secondaryLabel)
        secondaryLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(mainLabel.snp.bottom).offset(26)
        }
        
        scrollView.addSubview(phoneNumberTextField)
        phoneNumberTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(secondaryLabel.snp.bottom).offset(12)
            make.width.equalTo(260)
            make.height.equalTo(48)
        }
        
        scrollView.addSubview(confirmButton)
        confirmButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(phoneNumberTextField.snp.bottom).offset(148)
            make.width.equalTo(188)
            make.height.equalTo(47)
            
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

extension LoginScreen: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else { return false }
        let mask = "+#-###-###-##-##"
        let newString = (text as NSString).replacingCharacters(in: range, with: string)
        textField.text = Formatter.getFormattedNumber(from: newString, withMask: mask)
        confirmButton.isEnabled = (textField.text?.count == mask.count) ? true : false
        return false
    }
}
