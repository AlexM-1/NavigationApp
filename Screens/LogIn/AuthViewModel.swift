//
//  LogInViewModel.swift
//  Navigation
//
//  Created by Alex M on 01.02.2023.
//

import Foundation

final class AuthViewModel {

    private(set) var phoneNumber: String?

    private(set) var flow: Flow?

    enum Action {
        case registerAccountButtonTap
        case haveAccountButtonTap
        case backButtonTap
        case confirmNumberButtonTap(String)
        case nextButtonTap(String)
        case registerButtonTap(String)
    }

    enum State {
        case initial
        case loading
        case loaded
        case error
    }

    enum Flow {
        case register
        case login
    }


    private let coordinator: AppCoordinator

    var stateChanged: ((State) -> Void)?

    private(set) var state: State = .initial {
        didSet {
            stateChanged?(state)
        }
    }


    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
    }


    func changeState(_ action: Action) {
        switch action {

        case .registerAccountButtonTap:
            self.flow = .register
            self.coordinator.showRegistrationScreen()


        case .haveAccountButtonTap:
            self.flow = .login
            self.coordinator.showLoginScreen()


        case .backButtonTap:
            self.coordinator.showPrevScreen()


        case  .confirmNumberButtonTap(let phoneNumber), .nextButtonTap(let phoneNumber):
            self.phoneNumber = phoneNumber
            AuthManager.shared.startAuth(phoneNumber: phoneNumber)
            { [weak self] succsess, errorStr in
                guard succsess else {
                    self?.coordinator.showAlert(title: "Error".localizable, message: errorStr)
                    return }
                DispatchQueue.main.async {
                    self?.coordinator.showConfirmRegistrationScreen()
                }
            }


        case  .registerButtonTap(let code):
            let cleanCode = code.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
            AuthManager.shared.verifyCode(smsCode: cleanCode)
            { [weak self] succsess, errorStr in
                guard succsess else {
                    self?.coordinator.showAlert(title: "Error".localizable, message: errorStr)
                    return
                }

                if self?.flow == .login {
                    self?.state = .loading
                    NetworkService.shared.fetchUserProfile(phoneNumber: self!.phoneNumber!) { responce in
                        LocalStorage.shared.mainUser = responce
                        self?.state = .loaded
                        DispatchQueue.main.async {
                            self?.coordinator.showMainTabBar()
                        }
                    }
                }

                if self?.flow == .register {
                    self?.state = .loading
                    NetworkService.shared.createNewUserProfile { responce in
                        LocalStorage.shared.mainUser = responce
                        self?.state = .loaded
                        DispatchQueue.main.async {
                            self?.coordinator.showMainTabBar()
                        }
                    }
                }
            }
        }
    }
}


