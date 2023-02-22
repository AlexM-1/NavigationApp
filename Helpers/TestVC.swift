//
//  TestVC.swift
//  NavigationApp
//
//  Created by Alex M on 03.02.2023.
//

import UIKit
import SnapKit

class TestVC: UIViewController {

    init(backgroundColor: UIColor, title: String?) {
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = backgroundColor
        self.title = title
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let imageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "construction")
        view.contentMode = .scaleAspectFill
        return view
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(350)
            make.height.equalTo(250)
        }
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.standardAppearance.titlePositionAdjustment = .zero
        navigationController?.navigationBar.backItem?.title = "back".localizable
    }


}
