//
//  DefaultFetchWeatherForecastDataRepository.swift
//  WeatherApp
//
//  Created by Amir on 1/22/21.
//

import UIKit

final class DefaultFetchWeatherForecastDataRepository
{
    struct Dependency {
        let dataTransferService: DataTransferService
    }
    fileprivate let dependency: Dependency
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
}

extension DefaultFetchWeatherForecastDataRepository: FetchWeatherForecastDataRepository {
    func fetchWeatherForecastData(cityName: String, completion: @escaping (Result<WeatherData, Error>) -> Void) -> Cancellable? {
        let endPoint = APIEndpoints.fetchWetherForecastDataOfCity(cityName)
        let task = RepositoryTask()
        guard task.isCancelled == false else { return nil }
        task.networkTask = dependency.dataTransferService.request(with: endPoint) { (result) in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let err):
                completion(.failure(err))
            }
        }
        return task
    }
}
