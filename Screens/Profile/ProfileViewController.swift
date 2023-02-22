//
//  ProfileViewController.swift
//  NavigationApp
//
//  Created by Alex M on 05.02.2023.
//


import SnapKit
import UIKit


class ProfileViewController: UIViewController, UIGestureRecognizerDelegate {


    // MARK: - Init, View lifecycle
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        setTitle()
        bindViewModel()
        viewModel.changeState(.viewIsReady)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        setTitle()
        tableView.reloadData()
    }

    // MARK: - Private properties
    private let viewModel: ProfileViewModel
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private lazy var navigationBarView = NavigationBarView(title: viewModel.user.publicName ?? "", rigthButtonType: .menu)



    // MARK: - Public properties
    private var menuViewController: UIViewController!
    private var isMove = false
}

// MARK: - Private methods
private extension ProfileViewController {

    func setTitle() {

        switch viewModel.flow {
        case .userProfile:
            navigationController?.navigationBar.tintColor = StyleGuide.Colors.darkTitleColor
            let offset = UIOffset(horizontal: -CGFloat.greatestFiniteMagnitude, vertical: 0)
            navigationController?.navigationBar.standardAppearance.titlePositionAdjustment = offset
            if let publicName = viewModel.user.publicName {
                self.navigationItem.title = publicName
            }

        case .postAuthorProfile:
            navigationController?.isNavigationBarHidden = true
            navigationController?.interactivePopGestureRecognizer?.delegate = self
        }
    }


    func initialize() {
        view.backgroundColor = StyleGuide.Colors.lightBackgroundColor
        let menuBarButtonItem = UIBarButtonItem(image: UIImage(named: "menuIcon"), style: .plain, target: self, action: #selector(didTapMenuButton))
        menuBarButtonItem.tintColor = StyleGuide.Colors.orangeColor
        navigationItem.rightBarButtonItem = menuBarButtonItem
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = .clear
        tableView.backgroundColor = StyleGuide.Colors.lightBackgroundColor
        tableView.showsVerticalScrollIndicator = false
        tableView.register(FeedPostCell.self, forCellReuseIdentifier: String(describing: FeedPostCell.self))
        tableView.register(ProfileScrollPhotoCell.self, forCellReuseIdentifier: String(describing: ProfileScrollPhotoCell.self))

        view.addSubview(tableView)
        switch viewModel.flow {
        case .userProfile:
            tableView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        case .postAuthorProfile:

            view.addSubview(navigationBarView)
            navigationBarView.delegate = self
            navigationBarView.snp.makeConstraints { make in
                make.leading.trailing.top.equalToSuperview()
            }

            tableView.snp.makeConstraints { make in
                make.top.equalTo(navigationBarView.snp.bottom).offset(18)
                make.leading.bottom.trailing.equalToSuperview()
            }
        }

        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    private func bindViewModel() {
        viewModel.stateChanged = { [weak self] state in
            switch state {
            case .initial:
                print("")
            case .loading:
                DispatchQueue.main.async {
                    self?.activityIndicator.startAnimating()
                    self?.activityIndicator.isHidden = false
                }
            case .loaded:
                DispatchQueue.main.async {
                    self?.activityIndicator.stopAnimating()
                    self?.activityIndicator.isHidden = true
                    self?.tableView.reloadData()
                }
            case .error:
                print("error")

            case .showMenu:
                self?.switchMenuController()

            case  .closeMenu:
                self?.switchMenuController()
            }
        }
    }


    @objc func didTapMenuButton() {
        viewModel.changeState(.menuButtonDidTap)
    }


    func switchMenuController() {
        if menuViewController == nil {
            menuViewController = SideMenuViewController(viewModel: viewModel)
            view.addSubview(menuViewController.view)
            menuViewController.view.frame.origin.x = UIScreen.main.bounds.width
            addChild(menuViewController)
        }
        isMove.toggle()
        showMenuViewController(shouldMove: isMove)
    }


    func showMenuViewController(shouldMove: Bool) {
        if shouldMove {
            self.tableView.isUserInteractionEnabled = false
            self.navigationItem.rightBarButtonItem?.isEnabled = false

            // показываем menu
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut,
                           animations: {
                self.menuViewController.view.frame.origin.x =  UIScreen.main.bounds.width * 0.18
                self.tableView.alpha = 0.2
                self.navigationItem.title = ""

            }) { (finished) in



            }
        } else {
            // убираем menu
            tableView.isUserInteractionEnabled = true


            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut,
                           animations: {
                self.menuViewController.view.frame.origin.x = UIScreen.main.bounds.width
                self.tableView.alpha = 1.0
                if let publicName = self.viewModel.user.publicName {
                    self.navigationItem.title = publicName
                }
                self.navigationItem.rightBarButtonItem?.customView?.isHidden = false
                self.navigationItem.rightBarButtonItem?.isEnabled = true

            }) { (finished) in
                self.menuViewController.view.removeFromSuperview()
                self.menuViewController.removeFromParent()
                self.menuViewController = nil


            }
        }
    }

}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.dates.count + 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return 1 }
        let key = viewModel.dates[section - 1]
        let array = viewModel.postsDaySorted[key]
        return  array?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProfileScrollPhotoCell.self), for: indexPath) as! ProfileScrollPhotoCell
            cell.delegate = self
            cell.selectionStyle = .none
            cell.configure(with: viewModel.userPhotos)
            return cell
        }

        let key = viewModel.dates[indexPath.section - 1]
        let arr = viewModel.postsDaySorted[key]
        guard let post = arr?[indexPath.row] else {
            return UITableViewCell()
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FeedPostCell.self), for: indexPath) as! FeedPostCell
        cell.showMoreButtonAction = {
            self.viewModel.changeState(.showMoreButtonDidTap(post))
        }

        cell.likeButtonAction = {
            self.viewModel.changeState(.likeButtonDidTap(post))
        }

        cell.bookmarkButtonAction = {
            self.viewModel.changeState(.bookmarkButtonDidTap(post))
        }

        cell.configure(with: post)
        return cell
    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 140
        }
        if indexPath.section >= 1 {
            return 406
        }
        return UITableView.automaticDimension
    }


    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        if section == 0 {
            let profileHeaderView = ProfileHeaderView(user: viewModel.user as! UserProfileInfo, flow: viewModel.flow)
            profileHeaderView.delegate = self
            return profileHeaderView
        }

        if section >= 1 {
            return DataView(date: viewModel.dates[section - 1])
        }
        return nil
    }


    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 {
            switch viewModel.flow {
            case .userProfile:
                let searchView = SearchView(title: "My notes".localizable)
                searchView.searchButtonAction = {
                    self.viewModel.changeState(.searchButtonDidTap)
                }
                return searchView

            case .postAuthorProfile:
                let searchView = SearchView(title: "\("Posts".localizable) \(viewModel.user.name ?? "")")
                searchView.searchButtonAction = {
                    self.viewModel.changeState(.searchButtonDidTap)
                }
                return searchView
            }
        }
        return nil
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 40
        }
        return 0
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            switch viewModel.flow {
            case .userProfile:
                return 318
            case .postAuthorProfile:
                return 250
            }
        }
        if section >= 1 {
            return 48
        }
        return 24
    }
}


// MARK: - ProfileHeaderViewDelegate
extension ProfileViewController: ProfileScrollPhotoCellDelegate {
    func arrowForwardButtonDidTap(_ sender: ProfileScrollPhotoCell) {
        viewModel.changeState(.arrowForwardButtonDidTap)
    }

    func photoCellDidTap(_ sender: ProfileScrollPhotoCell, index: Int) {
        viewModel.changeState(.photoCellDidTap(index))
    }
}



// MARK: - ProfileScrollPhotoCellDelegate
extension ProfileViewController: ProfileHeaderViewDelegate {
    func messageButtonDidTap(_ sender: ProfileHeaderView) {
        viewModel.changeState(.messageButtonDidTap)
    }

    func callButtonDidTap(_ sender: ProfileHeaderView) {
        viewModel.changeState(.callButtonDidTap)
    }

    func editButtonDidTap(_ sender: ProfileHeaderView) {
        viewModel.changeState(.editButtonDidTap)
    }

    func detailedInformationButtonDidTap(_ sender: ProfileHeaderView) {
        viewModel.changeState(.detailedInformationButtonDidTap)
    }

    func noteButtonDidTap(_ sender: ProfileHeaderView) {
        viewModel.changeState(.noteButtonDidTap)
    }

    func historyButtonDidTap(_ sender: ProfileHeaderView) {
        viewModel.changeState(.historyButtonDidTap)
    }

    func photoButtonDidTap(_ sender: ProfileHeaderView) {
        viewModel.changeState(.photoButtonDidTap)
    }
}



// MARK: - NavigationBarViewDelegate
extension ProfileViewController: NavigationBarViewDelegate {
    func leftBarButtonDidTap(_ sender: NavigationBarView) {
        navigationController?.popViewController(animated: true)
    }

    func rightBarButtonDidTap(_ sender: NavigationBarView) {
    }
    
}

