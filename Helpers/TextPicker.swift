//
//  TextPicker.swift
//  NavigationApp
//
//  Created by Alex M on 09.02.2023.
//


import UIKit

class TextPicker {
    
    static let `default` = TextPicker()
    
    func showInfo(showIn viewController: UIViewController, title: String, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionCancel = UIAlertAction(title: "ok".localizable, style: .cancel)
        alertController.addAction(actionCancel)
        viewController.present(alertController, animated: true)
    }
    
    func confirmAction(showIn viewController: UIViewController,
                       title: String,
                       message: String?,
                       actionTitle: String,
                       action: (() -> Void)?
    ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionОК = UIAlertAction(title: actionTitle, style: .destructive) {_ in
            
            action?()
        }
        let actionCancel = UIAlertAction(title: "cancel".localizable, style: .cancel)
        alertController.addAction(actionОК)
        alertController.addAction(actionCancel)
        viewController.present(alertController, animated: true)
    }
    
    
}
