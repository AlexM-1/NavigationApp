//
//  DetailedProfileViewController.swift
//  NavigationApp
//
//  Created by Alex M on 17.02.2023.
//

import SnapKit
import UIKit


class DetailedProfileViewController: UIViewController {

    // MARK: - Init, View lifecycle
    init(viewModel: DetailedProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        setTapToHideKB()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }


    // MARK: - Private properties
    private let viewModel: DetailedProfileViewModel
    private var updateUser: UserProfileInfoProtocol!

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = .clear
        tableView.backgroundColor = StyleGuide.Colors.lightBackgroundColor
        tableView.showsVerticalScrollIndicator = false
        tableView.register(TextFieldMenuCell.self, forCellReuseIdentifier: String(describing: TextFieldMenuCell.self))
        tableView.register(ButtonsMenuCell.self, forCellReuseIdentifier: String(describing: ButtonsMenuCell.self))
        return tableView
    }()

}

// MARK: - Private methods
private extension DetailedProfileViewController {

    func initialize() {
        updateUser = viewModel.user
        view.backgroundColor = StyleGuide.Colors.lightBackgroundColor
        navigationController?.navigationBar.standardAppearance.titlePositionAdjustment = .zero


        switch viewModel.flow {
        case .userProfile:
            tableView.isUserInteractionEnabled = true
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "checkmark"), style: .plain, target: self, action: #selector(didTapOkButton))
            navigationItem.rightBarButtonItem?.tintColor = StyleGuide.Colors.orangeColor

            navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(didTapCancelButton))
            navigationItem.leftBarButtonItem?.tintColor = StyleGuide.Colors.orangeColor

        case .postAuthorProfile:
            tableView.isUserInteractionEnabled = false
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(didTapCancelButton))
            navigationItem.leftBarButtonItem?.tintColor = StyleGuide.Colors.orangeColor
        }

        navigationItem.title = "mainInfo".localizable

        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }


    private func setTapToHideKB() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func didTapOkButton() {
        viewModel.changeState(.okButtonDidTap(updateUser))

    }

    @objc func didTapCancelButton() {
        viewModel.changeState(.cancelButtonDidTap)
    }


}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension DetailedProfileViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.model.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.model[indexPath.section]
        switch item {

        case .textField(let textFieldItem):
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TextFieldMenuCell.self), for: indexPath) as! TextFieldMenuCell
            cell.delegate = self
            cell.configure(item: textFieldItem, tag: indexPath.section)
            return cell

        case .buttons(let buttonsItem):
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ButtonsMenuCell.self), for: indexPath) as! ButtonsMenuCell
            cell.configure(item: buttonsItem)
            cell.delegate = self
            return cell
        }
    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return " "
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as? UITableViewHeaderFooterView
        header?.textLabel?.font = StyleGuide.Fonts.mediumSize12
        header?.textLabel?.textColor = StyleGuide.Colors.darkTitleColor
        switch viewModel.model[section] {
        case .textField(let textFieldItem):
            header?.textLabel?.text = textFieldItem.title
        case .buttons(let buttonsItem):
            header?.textLabel?.text = buttonsItem.title
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        35
    }
}




extension DetailedProfileViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range:NSRange, replacementString string: String) -> Bool {

        guard let text = textField.text else { return false }
        let newString = (text as NSString).replacingCharacters(in: range, with: string)
        switch textField.tag
        {
        case 0:
            updateUser.name = newString
        case 1:
            updateUser.surname = newString
        case 2:
            print("")
        case 3:
            let mask = "##.##.####"
            let formattedString = Formatter.getFormattedNumber(from: newString, withMask: mask)
            textField.text = formattedString
            updateUser.dateOfBirth = formattedString
            return false
        case 4:
            updateUser.homeСity = newString
        default:
            print("")
        }
        return true
    }

}


extension DetailedProfileViewController: ButtonsMenuCellProtocol {
    func genderIsSelected(_ sender: ButtonsMenuCell, isMale: Bool) {
        updateUser.isMale = isMale
    }

}
