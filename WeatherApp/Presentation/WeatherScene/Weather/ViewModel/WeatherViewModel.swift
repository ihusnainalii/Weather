//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Amir on 1/24/21.
//

import UIKit


protocol WeatherInputViewModel {
    func refreshData()
}


protocol WeatherOutputViewModel {
    var cityName: String { get }
    var weatherData: Observable<WeatherData?> { get }
    var temperature: String { get }
    var apparentTemperature: String { get }
    var precipitationProbability: String { get }
    var windSpeed: String { get }
    var sunriseTime: String { get }
    var sunsetTime: String { get }
    var cloudCover: String { get }
    var visibility: String { get }
    var humidity: String { get }
    var summary: String { get }
    var icon: WeatherIcons { get }
    var rain: String { get }
    var rainTitle: String { get }
    var maxTemperature: String { get }
    var minTemperature: String { get }
    
    var days: Observable<[WeatherDayItemViewModel]> { get }
    var hours: Observable<[WeatherHourItemViewModel]> { get }
    
    var isLoading: Observable<Bool> { get }
    var errorMessage: Observable<String?> { get }
}

protocol WeatherViewModel: WeatherOutputViewModel, WeatherInputViewModel { }

final class DefaultWeatherViewModel: WeatherViewModel
{
    var days: Observable<[WeatherDayItemViewModel]> = Observable([])
    var hours: Observable<[WeatherHourItemViewModel]> = Observable([])
    var isLoading: Observable<Bool> = Observable(true)
    var errorMessage: Observable<String?> = Observable(.none)
     var rain: String {
        guard let value = weatherData.value?.list?.first?.snowOrRain.1 else { return "" }
        return "\(value)"
    }

     var rainTitle: String {
        guard let value = weatherData.value?.list?.first?.snowOrRain.0 else { return "" }
        return "\(value)"
    }

     var temperature: String {
        guard let value = weatherData.value?.list?.first?.main?.tempString else { return "" }
        return "\(value)"
    }
    
     var apparentTemperature: String {
        guard let value = weatherData.value?.list?.first?.main?.feelsLikeString else { return "" }
        return "\(value)"
        }
    
     var precipitationProbability: String {
        guard let value = weatherData.value?.list?.first?.main?.temp else { return "" }
        return "\(value)"
    }
    
     var windSpeed: String {
        guard let value = weatherData.value?.list?.first?.wind?.windSpeedString else { return "" }
        return "\(value)"
    }
    
     var sunriseTime: String {
        guard let value = weatherData.value?.city?.sunrise else { return "" }
        return Date.convertTimeIntervalToHourMinutesSeconds(TimeInterval(value))
    }
    
     var sunsetTime: String {
        guard let value = weatherData.value?.city?.sunset else { return "" }
        return Date.convertTimeIntervalToHourMinutesSeconds(TimeInterval(value))
    }
    
     var cloudCover: String {
        guard let value = weatherData.value?.list?.first?.clouds?.cloudCoverString else { return "" }
        return "\(value)"
    }
    
     var visibility: String {
        guard let value = weatherData.value?.list?.first?.visibilityString else { return "" }
        return "\(value)"
    }
    
     var humidity: String {
        guard let value = weatherData.value?.list?.first?.main?.humidityString else { return "" }
        return "\(value)"
    }
    
     var summary: String {
        guard let value = weatherData.value?.list?.first?.weather?.first?.desc else { return "" }
        return "\(value)"
    }
    
     var icon: WeatherIcons {
        guard let value = weatherData.value?.list?.first?.weather?.first?.icon,
              let icon = WeatherIcons(rawValue: value) else { return .unexpectedType }
        return icon
    }
    
     var maxTemperature: String {
        guard let value = weatherData.value?.list?.first?.main?.temp_min else { return "" }
        return "\(value)"
    }
    
     var minTemperature: String {
        guard let value = weatherData.value?.list?.first?.main?.temp_min else { return "" }
        return "\(value)"
    }
        
    var weatherData: Observable<WeatherData?> = Observable(.none)
    
     var cityName: String {
        return dependency.cityName
    }
    
    struct Dependency {
        let forecastWeatherUseCase: FetchWeatherForecastDataUseCase
        let cityName: String
    }
    
    fileprivate let dependency: Dependency
    private var weatherLoadTask: Cancellable? { willSet { weatherLoadTask?.cancel() } }

    init(dependency: Dependency) {
        self.dependency = dependency
        fetchWeatherData()
    }

    private func fetchWeatherData() {
        isLoading.value = true
         weatherLoadTask =
            dependency
            .forecastWeatherUseCase
            .execute(
                requestValue: CityNamesUseCaseRequestValue(city: dependency.cityName),
                completion: { [weak self]
                    (result) in
                    self?.isLoading.value = false
                    switch result {
                    case .success(let data):
                        self?.weatherData.value = data
                        self?.createDays()
                        self?.createHours()
                    case .failure(let err):
                        self?.handleError(err)
                    }
                })
        
    }
    private func createHours(){
        guard let lists = self.weatherData.value?.list else { return }
        let tempHours: [WeatherHourItemViewModel] = lists.map { DefaultWeatherHourItemViewModel(list: $0) }
        let count = tempHours.count > 17 ? 16 : tempHours.count
        hours.value = Array(tempHours[0..<count])
    }
    private func createDays() {
        guard let lists = self.weatherData.value?.list else { return }
        let tempDays: [WeatherDayItemViewModel] = lists.map { DefaultWeatherDayItemViewModel(list: $0) }
        days.value = tempDays.filter { $0.date.hour >= 8 && $0.date.hour <= 11 }
    }
    private func handleError(_ error: Error) {
        errorMessage.value = error.localizedDescription
    }
    func refreshData() {
        DispatchQueue.main.async {
            self.fetchWeatherData()
        }
    }
}
