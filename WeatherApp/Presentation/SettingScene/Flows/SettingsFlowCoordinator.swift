//
//  SettingsFlowCoordinator.swift
//  WeatherApp
//
//  Created by Amir on 1/24/21.
//

import UIKit
///Delegate some of tasks to other objects like setting di container
protocol SettingsFlowCoordinatorDelegate  {
    func makeSettingsViewController(actions: SettingsViewModelActions) -> SettingsViewController
    func makeLocationViewController(actions: LocationViewModelActions) -> ChooseLocationViewController
}
/// Help to coordinate settings with other view controllers
final class SettingsFlowCoordinator: NSObject
{
    weak var navigationController: UINavigationController?
    struct Dependency {
        let delegate: SettingsFlowCoordinatorDelegate
    }
    fileprivate let dependency: Dependency
    
    init(dependency: Dependency, navigationController: UINavigationController) {
        self.dependency = dependency
        self.navigationController = navigationController
    }
    private weak var settingsVC: SettingsViewController?
    
    func start() {
        let vc = dependency
            .delegate
            .makeSettingsViewController(
                actions: SettingsViewModelActions(moveToAddLocation: moveToAddLocation))
        navigationController?.pushViewController(vc, animated: true)
        settingsVC = vc
    }
    func moveToAddLocation() {
        let vc = dependency.delegate.makeLocationViewController(actions: LocationViewModelActions(back: backFromSearch))
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func backFromSearch() {
        navigationController?.popViewController(animated: true)
    }
}
