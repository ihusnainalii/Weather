//
//  FetchUserCitiesUseCase.swift
//  WeatherApp
//
//  Created by Amir on 1/23/21.
//

import UIKit

protocol FetchUserCitiesUseCase
{
    func execute(completion: @escaping (Result<[String], Error>) -> Void)
}

final class DefaultFetchUserCitiesUseCase
{
    struct Dependency {
        let citiesQueriesRepository: CitiesQueriesRepository
    }
    fileprivate let dependency: Dependency
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }

}

extension DefaultFetchUserCitiesUseCase: FetchUserCitiesUseCase {
    
    func execute(completion: @escaping (Result<[String], Error>) -> Void) {
        dependency.citiesQueriesRepository.fetchRecentsQueries(completion: completion)
    }
    
}
protocol SaveUserCityUseCase
{
    func execute(city:String, completion: @escaping (Result<[String], Error>) -> Void)
}

final class DefaultSavehUserCityUseCase
{
    struct Dependency {
        let citiesQueriesRepository: CitiesQueriesRepository
    }
    fileprivate let dependency: Dependency
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }

}

extension DefaultSavehUserCityUseCase: SaveUserCityUseCase {
    
    func execute(city:String ,completion: @escaping (Result<[String], Error>) -> Void) {
        dependency.citiesQueriesRepository.saveRecentQuery(city, completion: completion)
    }
    
}

protocol RemoveUserCityUseCase
{
    func execute(city:String, completion: @escaping (Result<[String], Error>) -> Void)
}

final class DefaultRemoveUserCityUseCase
{
    struct Dependency {
        let citiesQueriesRepository: CitiesQueriesRepository
    }
    fileprivate let dependency: Dependency
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }

}

extension DefaultRemoveUserCityUseCase: RemoveUserCityUseCase {
    
    func execute(city:String ,completion: @escaping (Result<[String], Error>) -> Void) {
        dependency.citiesQueriesRepository.removeQuery(city, completion: completion)
    }
    
}
