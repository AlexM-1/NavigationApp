//
//  DataView.swift
//  NavigationApp
//
//  Created by Alex M on 03.02.2023.
//

import SnapKit
import UIKit

class DataView: UIView {
    
    // MARK: - Init
    
    init(date: Date) {
        super.init(frame: .zero)
        let df = DateFormatter()
        df.dateFormat = "dd MMMM"
        dateLabel.text = df.string(from: date)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private constants
    
    private enum UIConstants {
        static let labelHeight: CGFloat = 24
        static let labelWidth: CGFloat = 100
        static let lineInset: CGFloat = 15
        static let lineToLabelOffset: CGFloat = 10
        static let lineWidth: CGFloat = 1
        
    }
    
    // MARK: - Private properties
    private let dateLabel = CustomLabel(
        titleColor: StyleGuide.Colors.grey2,
        font: StyleGuide.Fonts.regularSize14)

}

// MARK: - Private methods
private extension DataView {

    func initialize() {

        let horizontallLineViewLeft = UIView(frame: .zero)
        let horizontallLineViewRight = UIView(frame: .zero)
        horizontallLineViewLeft.backgroundColor = StyleGuide.Colors.grey2
        horizontallLineViewRight.backgroundColor = StyleGuide.Colors.grey2
        self.addSubview(horizontallLineViewLeft)
        self.addSubview(horizontallLineViewRight)
        self.addSubview(dateLabel)

        dateLabel.layer.cornerRadius = 10
        dateLabel.layer.borderWidth = 1.0
        dateLabel.layer.borderColor = StyleGuide.Colors.grey2.cgColor

        dateLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalTo(UIConstants.labelWidth)
            make.height.equalTo(UIConstants.labelHeight)
        }

        horizontallLineViewLeft.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(UIConstants.lineInset)
            make.trailing.equalTo(dateLabel.snp.leading).offset( -UIConstants.lineToLabelOffset)
            make.height.equalTo(UIConstants.lineWidth)
        }

        horizontallLineViewRight.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(UIConstants.lineInset)
            make.leading.equalTo(dateLabel.snp.trailing).offset( UIConstants.lineToLabelOffset)
            make.height.equalTo(UIConstants.lineWidth)

        }

    }
}

