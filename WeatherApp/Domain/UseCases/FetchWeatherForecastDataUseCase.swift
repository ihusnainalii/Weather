//
//  FetchWeatherForecastDataUseCase.swift
//  WeatherApp
//
//  Created by Amir on 1/22/21.
//

import UIKit

protocol FetchWeatherForecastDataUseCase
{
    func execute(requestValue: CityNamesUseCaseRequestValue,
                 completion: @escaping (Result<WeatherData, Error>) -> Void) -> Cancellable?
}
final class DefaultFetchWeatherForecastDataUseCase: FetchWeatherForecastDataUseCase {
    
    struct Dependency {
        let fetchWeatherForecastDataRepository: FetchWeatherForecastDataRepository
    }
    private let dependency: Dependency
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    func execute(requestValue: CityNamesUseCaseRequestValue,
                 completion: @escaping (Result<WeatherData, Error>) -> Void) -> Cancellable? {
        dependency.fetchWeatherForecastDataRepository.fetchWeatherForecastData(cityName: requestValue.city, completion: completion)
    }

}

