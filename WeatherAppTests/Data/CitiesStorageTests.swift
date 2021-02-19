//
//  CitiesStorageTests.swift
//  WeatherAppTests
//
//  Created by Amir on 1/25/21.
//

import XCTest
import WeatherApp

class CitiesStorageTests: XCTestCase {
    var storage: WeatherApp.CitiesStorage!
    var dummyData = ["Tehran", "London", "Stockholm"]
    override func setUpWithError() throws {
        storage =  DummyCitiesStorage()
    }
    
    override func tearDownWithError() throws {
        dummyData.forEach { storage.removeCity($0) { _ in } }
        storage = nil
    }
    
    func testThatSaveDataSuccessfully() {
        dummyData.forEach {
            storage.saveRecentCity($0) {
                switch $0 {
                case .failure(let error):
                    XCTAssert(false, error.localizedDescription)
                default: break;
                }
            }
        }
    }
    func testThatFetchCitiesCorrectly() {
        storage.fetchRecentsCities { [weak self] (result) in
            print(result)
            do {
                let data = try result.get()
                XCTAssert(data.elementsEqual(self!.dummyData))
            } catch {
                XCTAssert(false, error.localizedDescription)
            }
        }
    }
    
    func testThatDeleteCitiesCorrectly() {
        dummyData.forEach { [weak self] in
            storage.removeCity($0) { (result) in
                do {
                    let data = try result.get()
                    XCTAssert(data.elementsEqual(self!.dummyData))
                } catch {
                    XCTAssert(false, error.localizedDescription)
                }
            }
        }
    }
}

fileprivate class DummyCitiesStorage: WeatherApp.CitiesStorage
{
    private let dummyUserDefaultKey = "dummyUserDefaultKey"
    struct Dependency {
        let userDefaults: UserDefaults = .standard
    }
    private let dependency: Dependency
    
    init(dependency: Dependency = Dependency()) {
        self.dependency = dependency
    }
    
    private func fetchCities() -> [String] {
        return dependency.userDefaults.stringArray(forKey: dummyUserDefaultKey) ?? []
    }
    
    private func persist(cities: [String]) {
        dependency.userDefaults.set(cities, forKey: dummyUserDefaultKey)
    }
    
    
    func removeCity(_ cityName: String, completion: @escaping (Result<[String], Error>) -> Void) {
        DispatchQueue.main.async {
            var cities = self.fetchCities()
            cities.removeAll { $0 == cityName }
            self.persist(cities: cities)
            completion(.success(cities))
        }
    }
    
    
    func fetchRecentsCities(completion: @escaping (Result<[String], Error>) -> Void) {
        DispatchQueue.main.async {
            let cities = self.fetchCities()
            completion(.success(cities))
        }
    }
    
    func saveRecentCity(_ cityName: String, completion: @escaping (Result<[String], Error>) -> Void) {
        DispatchQueue.main.async {
            var cities = self.fetchCities()
            cities = cities.filter { $0 != cityName }
            cities.insert(cityName, at: 0)
            self.persist(cities: cities)
            completion(.success(cities))
        }
    }
    
}
