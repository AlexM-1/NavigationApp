//
//  SideMenuViewController.swift
//  NavigationApp
//
//  Created by Alex M on 17.02.2023.
//

import UIKit

enum MenuType {
    case profileMenu
    case userMenu
}

class SideMenuViewController: UIViewController {
    
    private var tableView: UITableView!
    private var viewModel: ProfileViewModel
    
    private lazy var closeButton = CustomButton(
        title: "",
        font: StyleGuide.Fonts.mediumSize16,
        backgroundColor: StyleGuide.Colors.grey4,
        imageTintColor: StyleGuide.Colors.orangeColor,
        imagePadding: 0,
        imagePlacement: .leading) {
            self.viewModel.changeState(.closeMenu)
        }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = StyleGuide.Colors.grey4
        configureButton()
        configureTableView()
    }
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SideMenuTableCell.self, forCellReuseIdentifier: SideMenuTableCell.description())
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(closeButton.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        tableView.separatorStyle = .none
        tableView.backgroundColor = StyleGuide.Colors.grey4
        
    }
    
    private func configureButton() {
        switch viewModel.menuType {
        case .profileMenu:
            closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        case .userMenu:
            closeButton.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        }
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(80)
            make.leading.equalToSuperview().offset(20)
            make.size.equalTo(40)
        }
    }
}

extension SideMenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewModel.menuType {
        case .profileMenu:
            return ProfileMenuModel.allCases.count
        case .userMenu:
            return UserMenuModel.allCases.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SideMenuTableCell.description()) as! SideMenuTableCell
        
        switch viewModel.menuType {
        case .profileMenu:
            let menuModel = ProfileMenuModel(rawValue: indexPath.row)
            cell.configure(image: menuModel?.image, description: menuModel?.description)
            return cell
        case .userMenu:
            let menuModel = UserMenuModel(rawValue: indexPath.row)
            cell.configure(image: menuModel?.image, description: menuModel?.description)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        viewModel.changeState(.menuDidTap(indexPath.row))
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return " "
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        let label = UILabel()
        
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalTo(view)
            make.leading.equalTo(view).offset(20)
        }
        
        label.font = StyleGuide.Fonts.mediumSize16
        label.textColor = StyleGuide.Colors.grey1
        switch viewModel.menuType {
        case .profileMenu:
            label.text = "profile".localizable
        case .userMenu:
            label.text = [ viewModel.user.name, viewModel.user.surname].compactMap { $0 }.joined(separator: " ")
        }
        
        let horizontallLineView = UIView()
        
        view.addSubview(horizontallLineView)
        horizontallLineView.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(10)
            make.leading.equalTo(view).offset(20)
            make.width.equalTo(UIScreen.main.bounds.width * 0.82 - 40)
            make.height.equalTo(1)
        }
        horizontallLineView.backgroundColor = StyleGuide.Colors.orangeColor
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        50
    }
    
}
