//
//  PhotoScrollItemCell.swift
//  NavigationApp
//
//  Created by Alex M on 07.02.2023.
//

import Foundation


import SnapKit
import UIKit

class PhotoScrollItemCell: UICollectionViewCell {
    
    private var imageScrollView: ImageScrollView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    func setupCell(image: UIImage) {
        imageScrollView.set(image: image)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        imageScrollView = ImageScrollView(frame: self.frame)
        
        contentView.addSubview(imageScrollView)
        imageScrollView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }
    
}
