//
//  AppConfiguration.swift
//  WeatherApp
//
//  Created by aakpro on 25.02.19.
//

import Foundation
///All main one time fetch app configuration from settings
final class AppConfiguration {
    lazy var apiBaseURL: String = {
        guard let apiBaseURL = Bundle.main.object(forInfoDictionaryKey: "ApiBaseURL") as? String else {
            fatalError("ApiBaseURL must not be empty in plist")
        }
        return apiBaseURL
    }()
    ///app id use to call api
    lazy var appId: String = {
        guard let appId = Bundle.main.object(forInfoDictionaryKey: "AppId") as? String else {
            fatalError("appId must not be empty in plist")
        }
        return appId
    }()
    /// local of app - can add localization 
    lazy var apiLocal: String = {
        return LanguageManager.shared.appLocale.identifier
    }()
    /// open weather api version
    lazy var apiVersion: String = {
        guard let appId = Bundle.main.object(forInfoDictionaryKey: "ApiVersion") as? String else {
            fatalError("apiVersion must not be empty in plist")
        }
        return appId
    }()
}
