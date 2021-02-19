//
//  FetchWeatherDataRepository.swift
//  WeatherApp
//
//  Created by Amir on 1/22/21.
//

import UIKit

protocol FetchWeatherDataRepository
{
    func fetchWeatherData(cityName: String, completion: @escaping (Result<WeatherData, Error>) -> Void) -> Cancellable?
}

protocol FetchWeatherForecastDataRepository
{
    func fetchWeatherForecastData(cityName: String, completion: @escaping (Result<WeatherData, Error>) -> Void) -> Cancellable?
}
