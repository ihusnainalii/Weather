//
//  AppFlowCoordinator.swift
//  WeatherApp
//
//  Created by aakpro on 03.03.19.
//

import UIKit

protocol AppFlowCoordinatorDelegate {
    func makeWeatherFlowCoordinator(navigationController: UINavigationController?) -> WeatherFlowCoordinator
}

///Controlls flow of app and handle coordination between them
///The main start point of app
final class AppFlowCoordinator: NSObject
{
    weak var navigationController: UINavigationController?
    struct Dependency {
        let delegate: AppFlowCoordinatorDelegate
    }
    private let dependency: Dependency
    
    init(dependency: Dependency, navigationController: UINavigationController) {
        self.dependency = dependency
        self.navigationController = navigationController
    }
    
    func start() {
        let flow = dependency.delegate.makeWeatherFlowCoordinator(navigationController: navigationController)
        flow.start()
    }
    
}
