//
//  PhotoSliderViewController.swift
//  NavigationApp
//
//  Created by Alex M on 06.02.2023.
//

import SnapKit
import UIKit

class PhotoSliderViewController: UIViewController {
    
    private var index: Int // указатель на текущий номер фото
    
    private var viewModel: PhotoSliderViewModel
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PhotoScrollItemCell.self, forCellWithReuseIdentifier: String(describing: PhotoScrollItemCell.self))
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        
        return collectionView
    }()
    
    init(index: Int,  viewModel: PhotoSliderViewModel) {
        self.index = index
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureController()
        setupView()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        
        DispatchQueue.main.async
        {
            self.collectionView.selectItem(at: IndexPath(row: self.index, section: 0), animated: false, scrollPosition: .centeredHorizontally)
            self.collectionView.isPagingEnabled = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    private func configureController(){
        navigationController?.navigationBar.standardAppearance.titlePositionAdjustment = .zero

        switch viewModel.flow {
        case .userProfile:
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(trashButtonTap))
        case .postAuthorProfile:
            navigationItem.rightBarButtonItem = nil
        }
        
        view.backgroundColor = StyleGuide.Colors.lightBackgroundColor
        navigationController?.isNavigationBarHidden = false
        
        title = "\(index + 1) из \(viewModel.images.count)"
        navigationController?.navigationBar.backItem?.title = "back".localizable
    }
    
    
    private func setupView() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.view)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func bindViewModel() {
        viewModel.stateChanged = { [weak self] state in
            switch state {
            case .initial:
                print("")
            case .update(let title, let index):
                DispatchQueue.main.async {
                    self?.title = title
                    self?.index = index
                    if self?.viewModel.images.count == 0 { self?.navigationItem.rightBarButtonItem?.isEnabled = false  }
                    self?.collectionView.reloadData()
                }
            }
        }
    }
    
    @objc func trashButtonTap() {
        viewModel.changeState(.trashButtonDidTap(index))
    }
}

// MARK: - UICollectionViewDataSource
extension PhotoSliderViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PhotoScrollItemCell.self), for: indexPath) as! PhotoScrollItemCell
        cell.setupCell(image: viewModel.images[indexPath.item])
        return cell
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let x = targetContentOffset.pointee.x
        let item = Int(x / view.frame.width)
        title = "\(item + 1) из \(viewModel.images.count)"
        index = item
    }
    
}


// MARK: - UICollectionViewDelegateFlowLayout
extension PhotoSliderViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let sideInset: CGFloat = 0
        return UIEdgeInsets(top: 0, left: sideInset, bottom: 0, right: sideInset)
    }
}

