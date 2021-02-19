//
//  DefaultCitiesQueriesRepository.swift
//  WeatherApp
//
//  Created by Amir on 1/23/21.
//

import UIKit

final class DefaultCitiesQueriesRepository
{
    struct Dependency {
        let storage: CitiesStorage
    }
    
    fileprivate let dependency: Dependency
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
}

extension DefaultCitiesQueriesRepository: CitiesQueriesRepository {
    func removeQuery(_ query: String, completion: @escaping (Result<[String], Error>) -> Void) {
        dependency.storage.removeCity(query, completion: completion)
    }
    
    func fetchRecentsQueries(completion: @escaping (Result<[String], Error>) -> Void) {
        dependency.storage.fetchRecentsCities(completion: completion)
    }
    
    func saveRecentQuery(_ query: String, completion: @escaping (Result<[String], Error>) -> Void) {
        dependency.storage.saveRecentCity(query, completion: completion)
    }
}
