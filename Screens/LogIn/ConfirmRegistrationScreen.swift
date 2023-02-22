//
//  ConfirmRegistrationScreen.swift
//  Navigation
//
//  Created by Alex M on 01.02.2023.
//


import UIKit

final class ConfirmRegistrationScreen: UIViewController {
    
    // MARK: - Private properties
    
    private let viewModel: AuthViewModel

    private let scrollView = UIScrollView()

    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    private lazy var mainLabel = CustomLabel(
        titleColor: StyleGuide.Colors.orangeColor,
        font: StyleGuide.Fonts.semiBoldSize18,
        title: "Confirmation of registration".localizable)
    
    private lazy var secondaryLabel = CustomLabel(
        titleColor: StyleGuide.Colors.grey1,
        font: StyleGuide.Fonts.regularSize14,
        numberOfLines: 2)
    
    private lazy var additionalLabel = CustomLabel(
        titleColor: StyleGuide.Colors.grey2,
        font: StyleGuide.Fonts.mediumSize12,
        title: "Enter the code from SMS".localizable)
    
    private lazy var codeTextField = CustomTextField(
        placeholder: "_ _ _ - _ _ _")
    
    
    private lazy var registerButton: CustomButton = {
        var title = "REGISTER".localizable
        if viewModel.flow == .login {
            title = "ENTER".localizable
        }
        let button = CustomButton(
            title: title,
            titleColor: StyleGuide.Colors.lightTitleColor,
            font: StyleGuide.Fonts.mediumSize16,
            backgroundColor: StyleGuide.Colors.darkBackgroundColor) {
                let code = self.codeTextField.text ?? ""
                self.viewModel.changeState(.registerButtonTap(code))
            }
        return button
    }()
    
    private lazy var image: UIImageView = {
        let view = UIImageView(image: UIImage(named: "checkmark"))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    
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
        codeTextField.delegate = self
        setupView()
        setTapToHideKB()
        bindViewModel()
    }
    
}



// MARK: - Private methods

private extension ConfirmRegistrationScreen {


    private func bindViewModel() {
        viewModel.stateChanged = { [weak self] state in
            switch state {
            case .initial:
                print("")
            case .loading:
                DispatchQueue.main.async {
                    self?.activityIndicator.startAnimating()
                }
            case .loaded:
                DispatchQueue.main.async {
                    self?.activityIndicator.stopAnimating()
                }
            case .error:
                print("error")
            }
        }
    }
    
    private func setupView() {
        
        setBoldPhoneNumber()
        registerButton.isEnabled = false
        
        if viewModel.flow == .login {
            mainLabel.text = "Login confirmation".localizable
        }

        view.backgroundColor = StyleGuide.Colors.lightBackgroundColor
        scrollView.showsVerticalScrollIndicator = false

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "arrowBack"), style: .plain, target: self, action: #selector(backButtonTap))
        self.navigationItem.leftBarButtonItem?.tintColor = StyleGuide.Colors.darkTitleColor


        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

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
            make.top.equalTo(mainLabel.snp.bottom).offset(12)
        }

        scrollView.addSubview(codeTextField)
        codeTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(secondaryLabel.snp.bottom).offset(138)
            make.width.equalTo(260)
            make.height.equalTo(48)
        }

        scrollView.addSubview(additionalLabel)
        additionalLabel.snp.makeConstraints { make in
            make.leading.equalTo(codeTextField.snp.leading)
            make.bottom.equalTo(codeTextField.snp.top).offset(-5)
        }

        scrollView.addSubview(registerButton)
        registerButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(codeTextField.snp.bottom).offset(86)
            make.width.equalTo(260)
            make.height.equalTo(48)
        }

        scrollView.addSubview(image)
        image.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(registerButton.snp.bottom).offset(43)
            make.width.equalTo(86)
            make.height.equalTo(100)

            make.bottom.equalToSuperview().inset(50)
        }


    }
    

    private func setBoldPhoneNumber() {
        // set bold phoneNumber in secondaryLabel
        let title = "We sent an SMS with a code to the number \n".localizable
        let phoneNumber = viewModel.phoneNumber ?? ""
        let attributedTitle = NSMutableAttributedString(string: title)
        let attrs = [NSAttributedString.Key.font: StyleGuide.Fonts.boldSize14]
        let boldPhoneNumber = NSMutableAttributedString(string: phoneNumber, attributes: attrs as [NSAttributedString.Key : Any])
        attributedTitle.append(boldPhoneNumber)
        
        secondaryLabel.attributedText = attributedTitle
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

extension ConfirmRegistrationScreen: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else { return false }
        let mask = "###-###"
        let newString = (text as NSString).replacingCharacters(in: range, with: string)
        textField.text = Formatter.getFormattedNumber(from: newString, withMask: mask)
        registerButton.isEnabled = (textField.text?.count == mask.count) ? true : false
        return false
    }
}
