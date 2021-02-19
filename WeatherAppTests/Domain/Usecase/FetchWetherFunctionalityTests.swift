//
//  WeatherAppTests.swift
//  WeatherAppTests
//
//  Created by Amir on 1/17/21.
//

import XCTest
@testable import WeatherApp

/// Can have conflicts with Data Transfer Service
/// Better to run independently
final class FetchWetherFunctionalityTests: XCTestCase {
    var repository: FetchWeatherDataRepository!
    var useCase: FetchWeatherDataUseCase!
    let stubData = ["Tehran", "London", "Stockholm"]
    override func setUp() {
        let apiDataTransferService = WeatherApp.DefaultDataTransferService(with: WeatherApp.DefaultNetworkService(config: WeatherApp.ApiDataNetworkConfig(baseURL: URL(string: "https://api.openweathermap.org/data/2.5")!)))
        repository = DefaultFetchWeatherDataRepository(dependency: DefaultFetchWeatherDataRepository.Dependency(dataTransferService: apiDataTransferService))
        useCase = DefaultFetchWeatherDataUseCase(dependency: DefaultFetchWeatherDataUseCase.Dependency(fetchWeatherDataRepository: repository))
    }
    
    override func tearDown() {
        useCase = nil
        repository = nil
    }
    
    func testIfCanFetchWeatherData() {
        for i in 0..<stubData.count {
            let time = Double(i * 3)
            DispatchQueue.main.asyncAfter(deadline: .now() + time) { [weak self] in
                self?.testDifferentCases(city: self?.stubData[i] ?? "")
            }
        }
    }
    func testDifferentCases(city: String) {
        let exp = self.expectation(description: "FetchWeatherDataUseCase is working \(city)")
        let _ = self.useCase?.execute(requestValue: CityNamesUseCaseRequestValue(city: city)) { result in
            switch result {
            case .success(let data):
                XCTAssertNotNil(data)
            case .failure(let error):
                XCTAssertNil(error, error.localizedDescription)
            }
            exp.fulfill()
        }
        self.waitForExpectations(timeout: 3.0, handler: nil)
    }
}
