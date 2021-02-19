//
//  AppDIContainer.swift
//  WeatherApp
//
//  Created by Amir on 1/2/21.
//

import UIKit

/// Main Dependency Injection Container of app
final class AppDIContainer {
    
    lazy var appConfiguration = AppConfiguration()
    
    // MARK: - Network
    lazy var apiDataTransferService: DataTransferService = {
        let config = ApiDataNetworkConfig(baseURL: URL(string: appConfiguration.apiBaseURL)!,
                                          version: appConfiguration.apiVersion,
                                          queryParameters: QueryParamsHelper(dependency: QueryParamsHelper.Dependency(appConfigurations: appConfiguration)).defaults())
        
        let apiDataNetwork = DefaultNetworkService(config: config)
        return DefaultDataTransferService(with: apiDataNetwork)
    }()
    //MARK: - Navigation Controller
    ///The one and only navigation controller of app
    lazy var navigationController: UINavigationController = {
        let navController = UINavigationController()
        return navController
    }()
    
    // MARK: - DIContainers of scenes
    func makeWeatherSceneDIContainer() -> WeatherSceneDIContainer {
        return WeatherSceneDIContainer(
            dependency: WeatherSceneDIContainer.Dependency(
                dataTransferService: apiDataTransferService,
                settingsFlowCoordinator:
                    makeSettingsSceneDIContainer()
                    .makeSettingsFlowCoordinator(
                        navigationController: navigationController)))
    }
    func makeSettingsSceneDIContainer() -> SettingsSceneDIContainer {
        return SettingsSceneDIContainer(
            dependency: SettingsSceneDIContainer
                .Dependency(
                    dataTransferService: apiDataTransferService))
    }
}

extension AppDIContainer: AppFlowCoordinatorDelegate {
    func makeWeatherFlowCoordinator(navigationController: UINavigationController?) -> WeatherFlowCoordinator {
        return makeWeatherSceneDIContainer().makeWeatherFlowCoordinator(navigationController: navigationController)
    }
}
