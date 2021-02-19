//
//  AppDelegate.swift
//  WeatherApp
//
//  Created by Amir on 1/17/21.
//

import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate
{
    
    /// Only dependency injection container of app
    let appDIContainer = AppDIContainer()
    /// Main flow coordinator
    var appFlowCoordinator: AppFlowCoordinator?
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        //Set local
        LanguageManager.shared.defaultLanguage = .en
        // Set global appearances
        AppAppearance.setupAppearance()
        //create ui and start app
        window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = appDIContainer.navigationController

        window?.rootViewController = navigationController
        appFlowCoordinator = AppFlowCoordinator(
            dependency: AppFlowCoordinator.Dependency(
                delegate: appDIContainer),
            navigationController: navigationController)
        appFlowCoordinator?.start()
        window?.makeKeyAndVisible()
        return true
    }
}
