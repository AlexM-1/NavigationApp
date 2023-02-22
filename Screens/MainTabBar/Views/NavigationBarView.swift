//
//  NavigationBarView.swift
//  NavigationApp
//
//  Created by Alex M on 03.02.2023.
//

import SnapKit
import UIKit

protocol NavigationBarViewDelegate: AnyObject {
    func leftBarButtonDidTap(_ sender: NavigationBarView)
    func rightBarButtonDidTap(_ sender: NavigationBarView)
}

enum RigthButtonType {
    case menu
    case plus
    case empty
}

class NavigationBarView: UIView {
    
    // MARK: - Init
    init(title: String, rigthButtonType: RigthButtonType) {
        self.rigthButtonType = rigthButtonType
        super.init(frame: .zero)
        self.titleLabel.text = title
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public properties
    weak var delegate: NavigationBarViewDelegate?
    
    
    // MARK: - Private constants
    private enum UIConstants {
        static let lineWidth: CGFloat = 1
        static let contentRightLeftInset: CGFloat = 25
        static let arrowToLabelOffset: CGFloat = 25
        static let titleLabelTopInset: CGFloat = 54
        static let lineToLabelOffset: CGFloat = 10
        static let navigationBarViewHeight: CGFloat = 86
    }
    
    
    
    
    // MARK: - Private properties
    private var rigthButtonType: RigthButtonType
    
    private let titleLabel = CustomLabel(
        titleColor: StyleGuide.Colors.darkTitleColor,
        font: StyleGuide.Fonts.mediumSize16)
    
    private let lineView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = StyleGuide.Colors.grey2
        return view
    }()
    
    private lazy var leftBarButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = StyleGuide.Colors.orangeColor
        button.setImage(UIImage(named: "arrowBackSmall"), for: .normal)
        button.titleLabel?.font = StyleGuide.Fonts.mediumSize16 ?? UIFont()
        let action = UIAction {_ in
            self.delegate?.leftBarButtonDidTap(self)
        }
        button.addAction(action, for: .touchUpInside)
        return button
    }()
    
    
    private lazy var rightBarButton: UIButton? = {
        
        switch rigthButtonType {
            
        case .menu:
            return ButtonWithMenuItems()
            
        case .plus:
            let button = UIButton(type: .system)
            button.tintColor = StyleGuide.Colors.orangeColor
            button.setImage(UIImage(systemName: "plus"), for: .normal)
            button.titleLabel?.font = StyleGuide.Fonts.mediumSize16 ?? UIFont()
            let action = UIAction {_ in
                self.delegate?.rightBarButtonDidTap(self)
            }
            button.addAction(action, for: .touchUpInside)
            return button
            
        case .empty:
            return nil
        }
    }()
}

// MARK: - Private methods
private extension NavigationBarView {
    
    func initialize() {
        
        self.backgroundColor = StyleGuide.Colors.lightBackgroundColor
        
        [titleLabel,
         lineView,
         leftBarButton
        ].forEach { self.addSubview($0) }
        
        
        self.snp.makeConstraints { make in
            make.height.equalTo(UIConstants.navigationBarViewHeight)
        }
        
        leftBarButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(UIConstants.contentRightLeftInset)
            make.top.equalToSuperview().inset(UIConstants.titleLabelTopInset)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(UIConstants.titleLabelTopInset)
            make.leading.equalTo(leftBarButton.snp.trailing).offset(UIConstants.arrowToLabelOffset)
        }
        
        if let rightBarButton = rightBarButton {
            self.addSubview(rightBarButton)
            rightBarButton.snp.makeConstraints { make in
                make.trailing.equalToSuperview().inset(UIConstants.contentRightLeftInset)
                make.top.equalToSuperview().inset(UIConstants.titleLabelTopInset)
            }
        }
        
        lineView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(UIConstants.contentRightLeftInset)
            make.top.equalTo(titleLabel.snp.bottom).offset(UIConstants.lineToLabelOffset)
            make.height.equalTo(UIConstants.lineWidth)
        }
    }
}


