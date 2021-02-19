//
//  SettingsSceneDIContainer.swift
//  WeatherApp
//
//  Created by Amir on 1/24/21.
//

import UIKit

/// Creates and inject all required dependencies to setting scene
final class SettingsSceneDIContainer
{
    struct Dependency {
        let dataTransferService: DataTransferService
    }
    
    fileprivate let dependency: Dependency
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    func makeSettingsFlowCoordinator(navigationController: UINavigationController) -> SettingsFlowCoordinator {
        return SettingsFlowCoordinator(dependency: SettingsFlowCoordinator.Dependency(delegate: self), navigationController: navigationController)
    }
}

extension SettingsSceneDIContainer: SettingsFlowCoordinatorDelegate {
    func makeLocationViewController(actions: LocationViewModelActions) -> ChooseLocationViewController {
        ChooseLocationViewController.create(with: makeChooseLocationViewModel(actions: actions))
    }
    
    func makeSettingsViewController(actions: SettingsViewModelActions) -> SettingsViewController {
        SettingsViewController.create(with: makeSettingsViewModel(actions: actions))
    }
    //MARK: - View Models
    func makeChooseLocationViewModel(actions: LocationViewModelActions) -> ChooseLocationViewModel {
        return DefaultChooseLocationViewModel(
            dependency: DefaultChooseLocationViewModel.Dependency(actions: actions, useCase: makeSaveUserCityUseCase()))
    }
    func makeSettingsViewModel(actions: SettingsViewModelActions) -> SettingsViewModel {
        return DefaultSettingsViewModel(
            dependency: DefaultSettingsViewModel
                .Dependency(
                    actions: actions,
                    saveUserCityUseCase: makeSaveUserCityUseCase(),
                    fetchUserCitiesUseCase: makeFetchUserCitiesUseCase(),
                    removeUseCase: makeRemoveUserCityUseCase(), fetchWeatherDataUseCase: makeFetchWeatherDataUseCase()))
    }
    //MARK: - UseCases
    func makeFetchWeatherDataUseCase() -> FetchWeatherDataUseCase {
        return DefaultFetchWeatherDataUseCase(dependency: DefaultFetchWeatherDataUseCase.Dependency(fetchWeatherDataRepository: makeFetchWeatherDataRepository()))
    }
    func makeSaveUserCityUseCase() -> SaveUserCityUseCase {
        return DefaultSavehUserCityUseCase(dependency: DefaultSavehUserCityUseCase.Dependency(citiesQueriesRepository: makeCitiesQueriesRepository()))
    }
    func makeFetchUserCitiesUseCase() -> FetchUserCitiesUseCase {
        return DefaultFetchUserCitiesUseCase(dependency: DefaultFetchUserCitiesUseCase.Dependency(citiesQueriesRepository: makeCitiesQueriesRepository()))
    }
    func makeRemoveUserCityUseCase() -> RemoveUserCityUseCase {
        return DefaultRemoveUserCityUseCase(dependency: DefaultRemoveUserCityUseCase.Dependency(citiesQueriesRepository: makeCitiesQueriesRepository()))
    }
    //MARK: - Repositories
    func makeCitiesQueriesRepository() -> CitiesQueriesRepository {
        return DefaultCitiesQueriesRepository(dependency: DefaultCitiesQueriesRepository.Dependency(storage: makeCitiesStorage()))
    }
    func makeFetchWeatherDataRepository() -> FetchWeatherDataRepository {
        return DefaultFetchWeatherDataRepository(dependency: DefaultFetchWeatherDataRepository.Dependency(dataTransferService: dependency.dataTransferService))
    }
    //MARK: - Storages
    func makeCitiesStorage() -> CitiesStorage {
        return UserDefaultsCitiesStorage()
    }
}
