//
//  SearchView.swift
//  NavigationApp
//
//  Created by Alex M on 07.02.2023.
//


import SnapKit
import UIKit

class SearchView: UIView {

    // MARK: - Init
     init(title: String) {
        super.init(frame: .zero)
        initialize(title: title)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private constants
    private enum UIConstants {
        static let height: CGFloat = 40
        static let inset: CGFloat = 16
    }

    // MARK: - Public properties
    var searchButtonAction: (() -> ())?

    // MARK: - Private properties
    private let label = CustomLabel(
        titleColor: StyleGuide.Colors.orangeColor,
        font: StyleGuide.Fonts.mediumSize16)

    private lazy var searchButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.tintColor = StyleGuide.Colors.darkTitleColor
        let action = UIAction {_ in
            self.searchButtonAction?()
        }
        button.addAction(action, for: .touchUpInside)
        return button
    }()
}


// MARK: - Private methods
private extension SearchView {

    func initialize(title: String) {
        self.backgroundColor = StyleGuide.Colors.grey4
        self.addSubview(label)
        label.text = title
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(UIConstants.inset)
        }

        self.addSubview(searchButton)
        searchButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(3)
            make.trailing.equalToSuperview().inset(UIConstants.inset)

        }
    }
}


