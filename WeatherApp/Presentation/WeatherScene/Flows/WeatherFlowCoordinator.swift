//
//  WeatherFlowCoordinator.swift
//  WeatherApp
//
//  Created by Amir on 1/17/21.
//

import UIKit

///Flow Coordinator for weather scene
protocol WeatherFlowCoordinatorDelegate  {
    func makeWeatherPageViewController(actions: WeatherPageViewModelActions) -> WeatherPageViewController
    func makeWeatherViewController(cityName: String) -> WeatherViewController
    func moveToSettingsViewController()
    func moveToChooseLocationsViewController()
}

final class WeatherFlowCoordinator: NSObject
{
    weak var navigationController: UINavigationController?

    struct Dependency {
        let delegate: WeatherFlowCoordinatorDelegate
        
    }
    private let dependency: Dependency
    
    init(dependency: Dependency, navigationController: UINavigationController?) {
        self.dependency = dependency
        self.navigationController = navigationController
    }
    
    private weak var weatherVC: WeatherPageViewController?
    
    func start() {
        // Note: here we keep strong reference with actions, this way this flow do not need to be strong referenced
        let actions = WeatherPageViewModelActions(
            createWeatherViewControllers: weatherViewControllers(cityNames:),
            showSettingView: showSettingViewController,
            showChooseLocationView: showLocationViewController)
        let vc = dependency.delegate.makeWeatherPageViewController(actions: actions)
        navigationController?.pushViewController(vc, animated: false)
        weatherVC = vc
    }
    
    private func weatherViewControllers(cityNames: [String]) -> [WeatherViewController] {
        return cityNames.map { weatherViewController(cityName: $0) }
    }
    
    private func showSettingViewController () {
        dependency.delegate.moveToSettingsViewController()
    }
    
    private func showLocationViewController () {
        dependency.delegate.moveToChooseLocationsViewController()
    }
    
    private func weatherViewController(cityName: String) -> WeatherViewController {
        return dependency.delegate.makeWeatherViewController(cityName: cityName)
    }
}
