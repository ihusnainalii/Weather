//
//  SettingsViewModel.swift
//  WeatherApp
//
//  Created by Amir on 1/24/21.
//

import UIKit

protocol SettingItemInputViewModel { }

protocol SettingItemOutputViewModel {
    var cityName: String { get } 
    var temperature: String { get }
    var icon: WeatherIcons { get }
}

protocol SettingItemViewModel: SettingItemOutputViewModel, SettingItemInputViewModel{ }

struct DefaultSettingItemViewModel: SettingItemViewModel
{
    let cityName: String
    let temperature: String
    let icon: WeatherIcons
}



struct SettingsViewModelActions {
    let moveToAddLocation: () -> Void
}
protocol SettingsInputViewModel {
    func navigateToAddLocation()
    func viewWillAppear()
    /// handle delete (by removing the data from your array and updating the tableview)
    func deleteItem(at index:Int)
}

protocol SettingsOutputViewModel {
    var items: Observable<[SettingItemViewModel]> { get }
    var count: Int { get }
    func item(at index: Int) -> SettingItemViewModel
    var errorMessage: Observable<String?> { get }
}

protocol SettingsViewModel: SettingsOutputViewModel, SettingsInputViewModel{ }

final class DefaultSettingsViewModel: SettingsViewModel
{
    var errorMessage = Observable<String?>(.none)

    var count: Int {
        return items.value.count
    }
    var items: Observable<[SettingItemViewModel]> = Observable([])
    struct Dependency {
        let actions: SettingsViewModelActions
        let saveUserCityUseCase: SaveUserCityUseCase
        let fetchUserCitiesUseCase: FetchUserCitiesUseCase
        let removeUseCase: RemoveUserCityUseCase
        let fetchWeatherDataUseCase: FetchWeatherDataUseCase
    }
    fileprivate let dependency: Dependency
    
    init(dependency: Dependency) {
        self.dependency = dependency
        fetchCities()
    }
    
    private func fetchCities() {
        dependency
            .fetchUserCitiesUseCase
            .execute {
                [weak self] (result) in
                switch result {
                case .success(let data):
                    self?.fetchWeatherData(cities: data)
                case .failure(let err):
                    self?.handle(err)
                }
            }
    }
    private func fetchWeatherData(cities: [String]) {
        cities.forEach { [weak self] (city) in
            let _ =
            self?.dependency.fetchWeatherDataUseCase.execute(requestValue: CityNamesUseCaseRequestValue(city: city), completion: {
                (result) in
                switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        self?.addItem(data: data)
                    }
                case .failure(let err):
                    self?.handle(err)
                }
            })
        }
    }
    private func handle(_ error: Error) {
        errorMessage.value = error.localizedDescription
    }   
    
    private func addItem(data: WeatherData) {
        guard let name = data.list?.first?.name else { return }
        guard let temperature = data.list?.first?.main?.tempString else { return }
        guard let iconName = data.list?.first?.weather?.first?.icon, let icon = WeatherIcons(rawValue: iconName) else {return}
        let item = DefaultSettingItemViewModel(cityName: name, temperature: temperature, icon: icon)
        guard items.value.contains(where: { $0.cityName == name }) == false else { return }
        items.value.append(item)
    }
}

extension DefaultSettingsViewModel {
    
    func navigateToAddLocation() {
        dependency.actions.moveToAddLocation()
    }
    
    func item(at index: Int) -> SettingItemViewModel {
        return items.value[index]
    }
    func viewWillAppear() {
        fetchCities()
    }
    
    func deleteItem(at index: Int) {
        let city = items.value[index]
        items.value.remove(at: index)
        dependency.removeUseCase.execute(city: city.cityName) { _ in }
    }
}
