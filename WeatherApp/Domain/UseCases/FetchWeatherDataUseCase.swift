//
//  FetchWeatherDataUseCase.swift
//  WeatherApp
//
//  Created by Amir on 1/19/21.
//

import UIKit

protocol FetchWeatherDataUseCase
{
    func execute(requestValue: CityNamesUseCaseRequestValue,
                 completion: @escaping (Result<WeatherData, Error>) -> Void) -> Cancellable?
}

final class DefaultFetchWeatherDataUseCase: FetchWeatherDataUseCase {
    
    struct Dependency {
        let fetchWeatherDataRepository: FetchWeatherDataRepository
    }
    private let dependency: Dependency
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    func execute(requestValue: CityNamesUseCaseRequestValue,
                 completion: @escaping (Result<WeatherData, Error>) -> Void) -> Cancellable? {
        dependency.fetchWeatherDataRepository.fetchWeatherData(cityName: requestValue.city, completion: completion)
    }
}

struct CityNamesUseCaseRequestValue {
    let city: String
}
