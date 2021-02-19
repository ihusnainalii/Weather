//
//  AppAppearance.swift
//  WeatherApp
//
//  Created by Oleh on 23.09.18.
//

import Foundation
import UIKit
///Setup global appearances here
final class AppAppearance {
    
    static func setupAppearance() {
        UINavigationBar.appearance().barTintColor = .systemTeal
        UINavigationBar.appearance().tintColor = .defaultColor
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.textColor, .font: UIFont.boldSystemFont(ofSize: 24)]
    }
}

