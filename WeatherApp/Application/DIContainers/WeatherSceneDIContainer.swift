//
//  WeatherSceneDIContainer.swift
//  WeatherApp
//
//  Created by Amir on 1/17/21.
//

import UIKit

/// Creates and inject all required dependencies to weather scene
final class WeatherSceneDIContainer
{
    struct Dependency {
        let dataTransferService: DataTransferService
        let settingsFlowCoordinator: SettingsFlowCoordinator
    }
    fileprivate let dependency: Dependency
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }

    func makeWeatherFlowCoordinator(navigationController: UINavigationController?) -> WeatherFlowCoordinator {
        return WeatherFlowCoordinator(dependency: WeatherFlowCoordinator.Dependency(delegate: self), navigationController: navigationController)
    }
}

extension WeatherSceneDIContainer: WeatherFlowCoordinatorDelegate {
    func makeWeatherViewController(cityName: String) -> WeatherViewController {
        return WeatherViewController.create(with: makeWeatherViewModel(cityName: cityName))
    }
    
    func makeWeatherPageViewController(actions: WeatherPageViewModelActions) -> WeatherPageViewController {
        return WeatherPageViewController.createViewController(with: makeWeatherPageViewModel(actions: actions))
    }    
    
    //MARK: - View Models
    private func makeWeatherPageViewModel(actions: WeatherPageViewModelActions) -> WeatherPageViewModel {
        return DefaultWeatherPageViewModel(dependency:
                                            DefaultWeatherPageViewModel.Dependency(
                                                fetchUseCase: makeFetchUserCitiesUseCase(),
                                                locationManager: makeLocationManager(),
                                                actions: actions))
    }
    private func makeWeatherViewModel(cityName: String) -> WeatherViewModel {
        return DefaultWeatherViewModel(
            dependency: DefaultWeatherViewModel
                .Dependency(
                    forecastWeatherUseCase: makeFetchWeatherForecastDataUseCase(),
                    cityName: cityName))
    }
    //MARK: - UseCases
    func makeFetchWeatherForecastDataUseCase() -> FetchWeatherForecastDataUseCase {
        return DefaultFetchWeatherForecastDataUseCase(dependency: DefaultFetchWeatherForecastDataUseCase.Dependency(fetchWeatherForecastDataRepository: makeFetchWeatherForecastDataRepository()))
    }
    func makeFetchUserCitiesUseCase() -> FetchUserCitiesUseCase {
        return DefaultFetchUserCitiesUseCase(dependency: DefaultFetchUserCitiesUseCase.Dependency(citiesQueriesRepository: makeCitiesQueriesRepository()))
    }
    
    //MARK: - Repositories
    func makeFetchWeatherForecastDataRepository() -> FetchWeatherForecastDataRepository {
        return DefaultFetchWeatherForecastDataRepository(dependency: DefaultFetchWeatherForecastDataRepository.Dependency(dataTransferService: dependency.dataTransferService))
    }
    func makeCitiesQueriesRepository() -> CitiesQueriesRepository {
        return DefaultCitiesQueriesRepository(dependency: DefaultCitiesQueriesRepository.Dependency(storage: makeCitiesStorage()))
    }
    func makeCitiesStorage() -> CitiesStorage {
        return UserDefaultsCitiesStorage()
    }
    //MARK: - Helpers
    func makeLocationManager() -> LocationManager {
        return LocationManager.shared
    }
    //MARK: - Move
    func moveToSettingsViewController() {
        dependency.settingsFlowCoordinator.start()
    }
    func moveToChooseLocationsViewController() {
        dependency.settingsFlowCoordinator.moveToAddLocation()
    }
}
