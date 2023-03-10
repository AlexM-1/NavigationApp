//
//  StyleGuide.swift
//  Navigation
//
//  Created by Alex M on 30.01.2023.
//

import UIKit


public final class StyleGuide {
    
    public enum Fonts {
        
        static let semiBoldSize18: UIFont? = UIFont(name: "Inter-SemiBold", size: 18)
        static let mediumSize16: UIFont? = UIFont(name: "Inter-Medium", size: 16)
        static let mediumSize14: UIFont? = UIFont(name: "Inter-Medium", size: 14)
        static let mediumSize12: UIFont? = UIFont(name: "Inter-Medium", size: 12)
        static let regularSize14: UIFont? = UIFont(name: "Inter-Regular", size: 14)
        static let regularSize12: UIFont? = UIFont(name: "Inter-Regular", size: 12)
        static let boldSize14: UIFont? = UIFont(name: "Inter-Bold", size: 14)
    }
    
    public enum Colors {
        
        static var lightBackgroundColor = createColor(lightMode: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), darkMode: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        
        static var darkBackgroundColor = createColor(lightMode: #colorLiteral(red: 0.17, green: 0.223, blue: 0.25, alpha: 1), darkMode: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))

        static var lightTitleColor = createColor(lightMode: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), darkMode: #colorLiteral(red: 0.122, green: 0.118, blue: 0.118, alpha: 1))

        static var darkTitleColor = createColor(lightMode: #colorLiteral(red: 0.122, green: 0.118, blue: 0.118, alpha: 1), darkMode: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))

        static let orangeColor: UIColor = #colorLiteral(red: 0.965, green: 0.592, blue: 0.027, alpha: 1)

        static var grey1 = createColor(lightMode: #colorLiteral(red: 0.149, green: 0.196, blue: 0.22, alpha: 1), darkMode: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))

        static var grey2 = createColor(lightMode: #colorLiteral(red: 0.494, green: 0.506, blue: 0.514, alpha: 1), darkMode: #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1))

        static var grey3 = createColor(lightMode: #colorLiteral(red: 0.851, green: 0.851, blue: 0.851, alpha: 1), darkMode: #colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1))

        static var grey4 = createColor(lightMode: #colorLiteral(red: 0.961, green: 0.953, blue: 0.933, alpha: 1), darkMode: #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1))

        static var grey5 = createColor(lightMode: #colorLiteral(red: 0.666, green: 0.691, blue: 0.704, alpha: 1), darkMode: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))

        static var blue = createColor(lightMode: #colorLiteral(red: 0.031, green: 0.387, blue: 0.921, alpha: 1), darkMode: #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1))

    }
    

    static func createColor(lightMode: UIColor, darkMode: UIColor) -> UIColor {
        guard #available(iOS 13.0, *) else {
            return lightMode
        }
        return UIColor { (traitCollection) -> UIColor in
            return traitCollection.userInterfaceStyle == .light ? lightMode : darkMode
        }
    }

}
