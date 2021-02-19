//
//  WeatherPageViewModelTests.swift
//  WeatherAppTests
//
//  Created by Amir on 1/26/21.
//

@testable import WeatherApp
import XCTest

class WeatherPageViewModelTests: XCTestCase
{
    private enum FetchRecentDataError: Error {
        case someError
    }
    
    
    let mockCities = ["city1", "city2", "city3"]
    class MockFetchUserCitiesUseCase: FetchUserCitiesUseCase {
        var expectation: XCTestExpectation!
        let error: Error?
        let mockCities: [String]
        init(_ cities: [String],_ err:Error? = nil) {
            self.mockCities = cities
            self.error = err
        }
        func execute(completion: @escaping (Result<[String], Error>) -> Void) {
            guard let err = self.error else {
                completion(.success(mockCities))
                expectation.fulfill()
                return
            }
            completion(.failure(err))
            expectation.fulfill()
        }
    }
    
    class MockSaveUserCityUseCase: SaveUserCityUseCase {
        func execute(city: String, completion: @escaping (Result<[String], Error>) -> Void) {
            completion(.success([]))
        }
    }
    
    func createViewModel (cities: [String] ,error: Error? = nil) -> WeatherPageViewModel {
        let useCase = MockFetchUserCitiesUseCase(cities, error)
        useCase.expectation = self.expectation(description: "Recent cities fetched")
        let actions = WeatherPageViewModelActions(
            createWeatherViewControllers: { _ in [] }, showSettingView: {}, showChooseLocationView: {})
        let viewModel = DefaultWeatherPageViewModel(
            dependency: DefaultWeatherPageViewModel.Dependency(
                fetchUseCase: useCase,
                locationManager: LocationManager.shared,
                actions:actions))
        return viewModel
    }
    
    func testWhenFetchCitiesThenCitiesAreTheSame() {
        let viewModel = createViewModel(cities: mockCities)
        viewModel.viewWillAppear()
        
        waitForExpectations(timeout: 0.1) { (error) in
            XCTAssertNil(error, error?.localizedDescription ?? "")
        }
        XCTAssertEqual(viewModel.cities.value, mockCities)
    }
    
    func testWhenFetchCitiesThenCreatePageViewModelWithErrorThenShowError() {
        let viewModel = createViewModel(cities: mockCities, error: FetchRecentDataError.someError)
        viewModel.viewWillAppear()
        viewModel.errorMessage.observe(on: self) { (message) in
            guard let m = message else { return }
            XCTAssertEqual(m, FetchRecentDataError.someError.localizedDescription)
        }
        
        waitForExpectations(timeout: 0.1) { (error) in
            XCTAssertNil(error, error?.localizedDescription ?? "")
        }
    }
    func testFirstLaunch() {
        let viewModel = createViewModel(cities: [])
        viewModel.retry()
        XCTAssertEqual(viewModel.cities.value, nil)
        waitForExpectations(timeout: 0.1) { (error) in
            XCTAssertNil(error, error?.localizedDescription ?? "")
        }
    }
}
