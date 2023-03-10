//
//  DetailedProfileViewModel.swift
//  NavigationApp
//
//  Created by Alex M on 17.02.2023.
//

import Foundation

final class DetailedProfileViewModel {

    enum Action {
        case okButtonDidTap(UserProfileInfoProtocol)
        case cancelButtonDidTap
    }

    let coordinator: ProfileCoordinator

    var user: UserProfileInfoProtocol
    let flow: Flow

    lazy var model: [MenuItem] = [
        .textField(TextFieldItem(title: "Name".localizable, placeholder: "name".localizable, type: .string, text: user.name)),
        .textField(TextFieldItem(title: "Surname".localizable, placeholder: "surname".localizable, type: .string, text: user.surname)),
        .buttons(ButtonsItem(title: "Gender".localizable, buttonNames: ["male".localizable, "female".localizable], isMale: user.isMale )),
        .textField(TextFieldItem(title: "Date of birth".localizable, placeholder: "01.01.2020", type: .date, text: user.dateOfBirth)),
        .textField(TextFieldItem(title: "Home city".localizable, placeholder: "Write the name".localizable, type: .string, text: user.homeСity))
    ]

    init(coordinator: ProfileCoordinator,
         user: UserProfileInfoProtocol,
         flow: Flow) {
        self.coordinator = coordinator
        self.user = user
        self.flow = flow
    }

    func changeState(_ action: Action) {
        switch action {
        case .okButtonDidTap(let user):
            if isDateCorrect(dateStr: user.dateOfBirth) {
                LocalStorage.shared.mainUser = user
                coordinator.showPrevScreen()
            } else {
                coordinator.showAlert(title: "The date of birth is incorrect".localizable, message: nil)
            }

        case .cancelButtonDidTap:
            coordinator.showPrevScreen()
        }
    }


    func isDateCorrect(dateStr: String?) -> Bool {
        guard let dateStr = dateStr else { return true }
        guard dateStr != "" else { return true }
        let df = DateFormatter()
        df.dateFormat = "dd.MM.yyyy"
        if let date = df.date(from: dateStr),
           date < Date() {
            return true
        } else {
            return false
        }
    }
}


