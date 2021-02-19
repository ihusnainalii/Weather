//
//  AssetsNames.swift
//  WeatherApp
//
//  Created by Amir on 1/15/21.
//

import UIKit
/// keep all asset names and helpers in one place
extension UIColor {
    static let defaultColor = UIColor.systemBackground
    static var textColor:UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                /// Return the color for Dark Mode
                return UIColor.black
            } else {
                /// Return the color for Light Mode
                return UIColor.white
            }
        }
    }()
    
    static let backgroundColor = UIColor.systemTeal
}
extension UIImage {
    static let defaultIcon = UIImage(.circle)
}

extension UIImage {
    convenience init?(_ symbol: SFSymbol) {
        self.init(systemName: symbol.rawValue)
    }
}

extension UIImage {
    convenience init?(_ icon: WeatherIcons) {
        self.init(systemName: icon.sfSymbol.rawValue)
    }
}
