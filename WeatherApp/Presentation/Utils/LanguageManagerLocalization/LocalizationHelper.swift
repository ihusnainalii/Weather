//
//  LocalizationHelper.swift
//  WeatherApp
//
//  Created by Amir on 1/4/21.
//

import Foundation

///localization helper to avoid mistakes
func LocalizedValue(_ key: LocalizationKeys) -> String {
    return NSLocalizedString(key.rawValue, comment: "")
}
func LocalizedValue(_ string: String) -> String {
    return NSLocalizedString(string, comment: "")
}

/// keep all localization in one place
enum LocalizationKeys:String {
    case noInternet = "No internet connection"
    case error
    case OK
    case retry
    case settingTitle = "Your Cities"
}

