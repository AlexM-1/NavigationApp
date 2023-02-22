//
//  PhotoGalleryViewController.swift
//  NavigationApp
//
//  Created by Alex M on 08.02.2023.
//

import SnapKit
import UIKit

final class PhotoGalleryViewController: UIViewController, UIGestureRecognizerDelegate {


    // MARK: - Private constants
    private enum UIConstants {
        static let cellWidth: CGFloat = 108
        static let cellHeight: CGFloat = 80
        static let spacing: CGFloat = 4
    }

    // MARK: - Private properties

    private var viewModel: PhotoGalleryViewModel

    private let activityIndicator = UIActivityIndicatorView(style: .large)

    private lazy var navigationBarView = NavigationBarView(
        title: "Photos".localizable,
        rigthButtonType: (viewModel.flow == .userProfile) ? .plus : .empty)


    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PhotoItemCell.self, forCellWithReuseIdentifier: String(describing: PhotoItemCell.self))
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()


    // MARK: - Init
    init(viewModel: PhotoGalleryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }

    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
        collectionView.reloadData()
    }

}

// MARK: - Private methods
private extension PhotoGalleryViewController {

    func initialize() {
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationBarView.delegate = self
        view.backgroundColor = StyleGuide.Colors.lightBackgroundColor

        view.addSubview(navigationBarView)
        navigationBarView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
        }

        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(navigationBarView.snp.bottom).offset(UIConstants.spacing)
            make.bottom.equalToSuperview()
        }

        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

// MARK: - UICollectionViewDataSource
extension PhotoGalleryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PhotoItemCell.self), for: indexPath) as! PhotoItemCell
        cell.setupCell(image: viewModel.images[indexPath.item], cornerRadius: 8)
        return cell
    }
}


// MARK: - UIScrollViewDelegate
extension PhotoGalleryViewController: UIScrollViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.changeState(.photoDidTap(indexPath.item))
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PhotoGalleryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: UIConstants.cellWidth, height: UIConstants.cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        UIConstants.spacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        UIConstants.spacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        let sideInset = (UIScreen.main.bounds.width - UIConstants.cellWidth * 3 - 2 * UIConstants.spacing) / 2
        return UIEdgeInsets(top: 0, left: sideInset, bottom: 0, right: sideInset)
    }
}


// MARK: - NavigationBarViewDelegate
extension PhotoGalleryViewController: NavigationBarViewDelegate {

    func leftBarButtonDidTap(_ sender: NavigationBarView) {
        navigationController?.popViewController(animated: true)
    }

    func rightBarButtonDidTap(_ sender: NavigationBarView) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
}


// MARK: - NavigationBarViewDelegate
extension PhotoGalleryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        viewModel.changeState(.receivedImageFromPicker(image))
        self.dismiss(animated: true)
        self.collectionView.reloadData()
    }
}


