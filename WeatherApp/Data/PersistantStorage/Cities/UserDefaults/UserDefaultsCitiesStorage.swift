//
//  UserDefaultsCitiesStorage.swift
//  WeatherApp
//
//  Created by Amir on 1/19/21.
//

import UIKit

///Implement CitiesStorage
///This implementation uses UserDefaults
final public class UserDefaultsCitiesStorage
{
    private let citiesUserDefaultKey = "citiesUserDefaultKey"
    struct Dependency {
        let userDefaults: UserDefaults = .standard
    }
    private let dependency: Dependency
    
    init(dependency: Dependency = Dependency()) {
        self.dependency = dependency
    }
    
    private func fetchCities() -> [String] {
        return dependency.userDefaults.stringArray(forKey: citiesUserDefaultKey) ?? []
    }
    
    private func persist(cities: [String]) {
        dependency.userDefaults.set(cities, forKey: citiesUserDefaultKey)
    }
    
}
extension UserDefaultsCitiesStorage: CitiesStorage {
    public func removeCity(_ cityName: String, completion: @escaping (Result<[String], Error>) -> Void) {
        DispatchQueue.main.async {
            var cities = self.fetchCities()
            cities.removeAll { $0 == cityName }
            self.persist(cities: cities)
            completion(.success(cities))
        }
    }
    
    public func fetchRecentsCities(completion: @escaping (Result<[String], Error>) -> Void) {
        DispatchQueue.main.async {
            let cities = self.fetchCities()
            completion(.success(cities))
        }
    }
    
    public func saveRecentCity(_ cityName: String, completion: @escaping (Result<[String], Error>) -> Void) {
        DispatchQueue.main.async {
            var cities = self.fetchCities()
            cities = cities.filter { $0 != cityName }
            cities.insert(cityName, at: 0)
            self.persist(cities: cities)
            completion(.success(cities))
        }
    }
}
