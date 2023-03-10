//
//  FeedViewController2.swift
//  Navigation
//
//  Created by Alex M on 02.02.2023.
//


import SnapKit
import UIKit


class FeedViewController: UIViewController {


    // MARK: - Init
    init(viewModel: FeedViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        initNavigationBar()
        initTableView()
        viewModel.changeState(.viewIsReady)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        tableView.reloadData()
    }
    
    // MARK: - Private properties
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let viewModel: FeedViewModel
    private let activityIndicator = UIActivityIndicatorView(style: .large)

}


// MARK: - Private methods
private extension FeedViewController {
    
    func initNavigationBar() {
        navigationController?.navigationBar.tintColor = StyleGuide.Colors.darkTitleColor
        navigationItem.title = "Main".localizable
        
        let offset = UIOffset(horizontal: -CGFloat.greatestFiniteMagnitude, vertical: 0)
        navigationController?.navigationBar.standardAppearance.titlePositionAdjustment = offset

        let searchBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(didTapSearchButton))
        
        let bellBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "bell"), style: .plain, target: self, action: #selector(didTapBellButton))

        navigationItem.rightBarButtonItems = [bellBarButtonItem, searchBarButtonItem]
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
            }
        }
    }
    
    func initTableView() {
        view.backgroundColor = StyleGuide.Colors.lightBackgroundColor
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = .clear
        tableView.backgroundColor = StyleGuide.Colors.lightBackgroundColor
        tableView.showsVerticalScrollIndicator = false
        tableView.register(FeedStoriesSetCell.self, forCellReuseIdentifier: String(describing: FeedStoriesSetCell.self))
        tableView.register(FeedPostCell.self, forCellReuseIdentifier: String(describing: FeedPostCell.self))
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    
    @objc func didTapSearchButton() {
        print("didTapMagnifierButton")
    }
    
    @objc func didTapBellButton() {
        print("didTapBellButton")
    }

}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension FeedViewController: UITableViewDataSource, UITableViewDelegate {

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
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FeedStoriesSetCell.self), for: indexPath) as! FeedStoriesSetCell
            cell.configure(with: viewModel.stories)
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

        cell.commentButtonAction = {
            self.viewModel.changeState(.commentButtonDidTap(post))
        }

        cell.showPostAuthorProfileAction = {
            self.viewModel.changeState(.showUserInfoDidTap(post.userID))
        }

        cell.configure(with: post)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 100
        }
        if indexPath.section >= 1 {
            return 406
        }
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section >= 1 {
            return DataView(date: viewModel.dates[section - 1])
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section >= 1 {
            return 24
        }
        return 0
    }
}



