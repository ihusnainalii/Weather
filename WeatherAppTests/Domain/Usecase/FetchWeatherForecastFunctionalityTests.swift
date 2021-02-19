//
//  FetchWeatherForecastFunctionalityTests.swift
//  WeatherAppTests
//
//  Created by Amir on 1/22/21.
//

import XCTest
@testable import WeatherApp

final class FetchWeatherForecastFunctionalityTests: XCTestCase
{
    var di: AppDIContainer!
    var repository: FetchWeatherForecastDataRepository!
    var useCase: FetchWeatherForecastDataUseCase!
    let stubData = ["Tehran", "London", "Stockholm"]
    override func setUp() {
        di = AppDIContainer()
        repository = DefaultFetchWeatherForecastDataRepository(dependency: DefaultFetchWeatherForecastDataRepository.Dependency(dataTransferService: di.apiDataTransferService))
        useCase = DefaultFetchWeatherForecastDataUseCase(dependency: DefaultFetchWeatherForecastDataUseCase.Dependency(fetchWeatherForecastDataRepository: repository))
    }
    
    override func tearDown() {
        useCase = nil
        repository = nil
        di = nil
    }
    //Must be run independetly
    func testIfCanFetchWeatherData() {
        stubData.forEach {
            testDifferentCases(city: $0)
        }
    }
    
    func testDifferentCases(city: String) {
        let exp = expectation(description: "FetchWeatherForecastDataUseCase is not working ==> \(city)")
        exp.assertForOverFulfill = false
        let _ = useCase.execute(requestValue: CityNamesUseCaseRequestValue(city: city)) { (result) in
            exp.fulfill()
            switch result {
            case .success(let data):
                XCTAssertNotNil(data)
            case .failure(let err):
                XCTAssertNil(err)
            }
        }
        
        wait(for: [exp], timeout: 3.0)
    }
    
}
