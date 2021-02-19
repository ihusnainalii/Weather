//
//  DefaultFetchWeatherDataRepository.swift
//  WeatherApp
//
//  Created by Amir on 1/22/21.
//

import UIKit

final class DefaultFetchWeatherDataRepository
{
    struct Dependency {
        let dataTransferService: DataTransferService
    }
    fileprivate let dependency: Dependency
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
}
extension DefaultFetchWeatherDataRepository: FetchWeatherDataRepository {
    func fetchWeatherData(cityName: String, completion: @escaping (Result<WeatherData, Error>) -> Void) -> Cancellable? {
        let endPoint = APIEndpoints.fetchWetherDataOfCity(cityName)
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
