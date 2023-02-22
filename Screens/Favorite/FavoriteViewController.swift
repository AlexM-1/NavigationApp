//
//  FavoriteViewController.swift
//  NavigationApp
//
//  Created by Alex M on 08.02.2023.
//

import SnapKit
import UIKit
import CoreData

final class FavoriteViewController: UIViewController, UISearchResultsUpdating {

    // MARK: - Private properties
    private let titleLabel = CustomLabel(
        titleColor: StyleGuide.Colors.darkTitleColor,
        font: StyleGuide.Fonts.mediumSize16,
        title: "Saved".localizable)

    private let lineView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = StyleGuide.Colors.grey2
        return view
    }()

    private let tableView = UITableView(frame: .zero, style: .grouped)

    private var fetchedResultsController: NSFetchedResultsController<Post>!

    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search by text".localizable
        searchController.searchResultsUpdater = self
        self.navigationItem.searchController = searchController
        return searchController
    }()



    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        initTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
        initFetchResultsController()
        tableView.reloadData()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.isNavigationBarHidden = true
    }

}

// MARK: - Private methods
extension FavoriteViewController {

    private func initialize() {
        view.backgroundColor = StyleGuide.Colors.lightBackgroundColor
        navigationController?.navigationBar.tintColor = StyleGuide.Colors.darkTitleColor
        self.navigationItem.title = "Saved".localizable
        //navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(trashButtonTap))
    }

    private func initTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = .clear
        tableView.backgroundColor = StyleGuide.Colors.lightBackgroundColor
        tableView.showsVerticalScrollIndicator = true
        tableView.register(FeedStoriesSetCell.self, forCellReuseIdentifier: String(describing: FeedStoriesSetCell.self))
        tableView.register(FeedPostCell.self, forCellReuseIdentifier: String(describing: FeedPostCell.self))
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }


    private func initFetchResultsController() {
        let request = Post.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "created_at", ascending: false)]

        if let searchText = searchController.searchBar.text,
           searchText != "" {
            request.predicate = NSPredicate(format: "postText contains[c] %@", searchText)
        }

        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataManager.default.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        try? frc.performFetch()
        fetchedResultsController = frc
        fetchedResultsController.delegate = self


        if fetchedResultsController.sections?[0].numberOfObjects == 0 {
            navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }

    func updateSearchResults(for searchController: UISearchController) {
        initFetchResultsController()
        tableView.reloadData()
    }

    @objc func trashButtonTap() {
        TextPicker.default.confirmAction(
            showIn: self,
            title: "Clear favorites?".localizable,
            message: "This action cannot be canceled".localizable,
            actionTitle: "Delete all entries".localizable) {
                CoreDataManager.default.deleteAllPosts()
            }
    }

}



// MARK: - UITableViewDataSource, UITableViewDelegate
extension FavoriteViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let post = fetchedResultsController.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FeedPostCell.self), for: indexPath) as! FeedPostCell

        cell.showMoreButtonAction = {
            let controller = OnePostViewController()
            controller.configure(post: post)
            self.navigationController?.pushViewController(controller, animated: true)
        }
        cell.configure(with: post)
        return cell

    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        406
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let post = fetchedResultsController.object(at: indexPath)
            CoreDataManager.default.deletePost(post: post)
        } else if editingStyle == .insert {
        }

    }
}


extension FavoriteViewController: NSFetchedResultsControllerDelegate {

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .move:
            guard let indexPath = indexPath, let newIndexPath = newIndexPath else { return }
            tableView.moveRow(at: indexPath, to: newIndexPath)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        @unknown default:
            print("Fatal error")
        }

        if controller.sections?[0].numberOfObjects == 0 {
            navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
}








