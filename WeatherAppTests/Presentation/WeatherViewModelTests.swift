//
//  WeatherViewModelTests.swift
//  WeatherAppTests
//
//  Created by Amir on 1/26/21.
//

import XCTest
@testable import WeatherApp

class WeatherViewModelTests: XCTestCase {
    private enum FetchRecentDataError: Error {
        case someError
        case noData
    }
    
    
    let mockCities = ["city1", "city2", "city3"]
    class MockFetchWeatherForecastDataUseCase: FetchWeatherForecastDataUseCase {
        var expectation: XCTestExpectation!
        let error: Error?
        let mockCity: String
        init(_ city: String,_ err:Error? = nil) {
            self.mockCity = city
            self.error = err
        }
        func execute(requestValue: CityNamesUseCaseRequestValue, completion: @escaping (Result<WeatherData, Error>) -> Void) -> Cancellable? {
            if let err = self.error {
                completion(.failure(err))
            }
            else if let data = WeatherData.createMockData(mockDataJson) {
                completion(.success(data))
            } else {
                completion(.failure(FetchRecentDataError.noData))
            }
            
            expectation.fulfill()
            return nil
        }
    }
    
    func createViewModel (error: Error? = nil) -> WeatherViewModel {
        let useCase = MockFetchWeatherForecastDataUseCase(mockCities.first!)
        useCase.expectation = self.expectation(description: "weather Data fetched")
        useCase.expectation.assertForOverFulfill = false
        let viewModel = DefaultWeatherViewModel(
            dependency: DefaultWeatherViewModel.Dependency(
                forecastWeatherUseCase: useCase,
                cityName: mockCities.first!))
        return viewModel
    }
    
    func testThatFetchDataThenCreateViewModelsAndStopLoading() {
        let viewModel = createViewModel()
        viewModel.refreshData()
        XCTAssertEqual(viewModel.cityName, mockCities.first!)
        XCTAssertNotNil(viewModel.weatherData.value)
        XCTAssertNotNil(viewModel.apparentTemperature)
        XCTAssertNotNil(viewModel.precipitationProbability)
        XCTAssertNotNil(viewModel.windSpeed)
        XCTAssertNotNil(viewModel.sunriseTime)
        XCTAssertNotNil(viewModel.sunsetTime)
        XCTAssertNotNil(viewModel.cloudCover)
        XCTAssertNotNil(viewModel.visibility)
        XCTAssertNotNil(viewModel.humidity)
        XCTAssertNotNil(viewModel.summary)
        XCTAssertNotNil(viewModel.icon)
        XCTAssertNotNil(viewModel.rain)
        XCTAssertNotNil(viewModel.rainTitle)
        XCTAssertNotNil(viewModel.maxTemperature)
        XCTAssertNotNil(viewModel.minTemperature)
        XCTAssertNotNil(viewModel.days.value)
        XCTAssertNotNil(viewModel.hours.value)
        XCTAssertNotNil(viewModel.isLoading)
        
        XCTAssertFalse(viewModel.isLoading.value)
        
        waitForExpectations(timeout: 0.1) { (err) in
            XCTAssertNil(err, err?.localizedDescription ?? "")
        }
    }
    
}

fileprivate extension WeatherData {
    static func createMockData(_ json: String) -> WeatherData? {
        guard let data = json.data(using: .utf8) else { return nil }
        let decoder = JSONDecoder()
        let result = try? decoder.decode(WeatherData.self, from: data)
        return result
    }
}

let mockDataJson = """
{"cod":"200","message":0,"cnt":40,"list":[{"dt":1611684000,"main":{"temp":5.91,"feels_like":2.38,"temp_min":5.17,"temp_max":5.91,"pressure":1021,"sea_level":1021,"grnd_level":886,"humidity":39,"temp_kf":0.74},"weather":[{"id":802,"main":"Clouds","description":"scattered clouds","icon":"03n"}],"clouds":{"all":45},"wind":{"speed":1.03,"deg":36},"visibility":10000,"pop":0,"sys":{"pod":"n"},"dt_txt":"2021-01-26 18:00:00"},{"dt":1611694800,"main":{"temp":4.86,"feels_like":1.34,"temp_min":4.38,"temp_max":4.86,"pressure":1022,"sea_level":1022,"grnd_level":886,"humidity":45,"temp_kf":0.48},"weather":[{"id":800,"main":"Clear","description":"clear sky","icon":"01n"}],"clouds":{"all":9},"wind":{"speed":1.15,"deg":24},"visibility":10000,"pop":0,"sys":{"pod":"n"},"dt_txt":"2021-01-26 21:00:00"},{"dt":1611705600,"main":{"temp":4.01,"feels_like":0.61,"temp_min":3.83,"temp_max":4.01,"pressure":1022,"sea_level":1022,"grnd_level":886,"humidity":47,"temp_kf":0.18},"weather":[{"id":800,"main":"Clear","description":"clear sky","icon":"01n"}],"clouds":{"all":3},"wind":{"speed":0.94,"deg":4},"visibility":10000,"pop":0,"sys":{"pod":"n"},"dt_txt":"2021-01-27 00:00:00"},{"dt":1611716400,"main":{"temp":3.46,"feels_like":0.14,"temp_min":3.43,"temp_max":3.46,"pressure":1023,"sea_level":1023,"grnd_level":886,"humidity":46,"temp_kf":0.03},"weather":[{"id":800,"main":"Clear","description":"clear sky","icon":"01n"}],"clouds":{"all":0},"wind":{"speed":0.73,"deg":1},"visibility":10000,"pop":0,"sys":{"pod":"n"},"dt_txt":"2021-01-27 03:00:00"},{"dt":1611727200,"main":{"temp":6.84,"feels_like":3.88,"temp_min":6.84,"temp_max":6.84,"pressure":1023,"sea_level":1023,"grnd_level":888,"humidity":43,"temp_kf":0},"weather":[{"id":800,"main":"Clear","description":"clear sky","icon":"01d"}],"clouds":{"all":0},"wind":{"speed":0.52,"deg":202},"visibility":10000,"pop":0,"sys":{"pod":"d"},"dt_txt":"2021-01-27 06:00:00"},{"dt":1611738000,"main":{"temp":9.06,"feels_like":5.87,"temp_min":9.06,"temp_max":9.06,"pressure":1021,"sea_level":1021,"grnd_level":887,"humidity":39,"temp_kf":0},"weather":[{"id":800,"main":"Clear","description":"clear sky","icon":"01d"}],"clouds":{"all":0},"wind":{"speed":0.96,"deg":163},"visibility":10000,"pop":0,"sys":{"pod":"d"},"dt_txt":"2021-01-27 09:00:00"},{"dt":1611748800,"main":{"temp":10.01,"feels_like":6.56,"temp_min":10.01,"temp_max":10.01,"pressure":1019,"sea_level":1019,"grnd_level":885,"humidity":37,"temp_kf":0},"weather":[{"id":800,"main":"Clear","description":"clear sky","icon":"01d"}],"clouds":{"all":1},"wind":{"speed":1.35,"deg":216},"visibility":10000,"pop":0,"sys":{"pod":"d"},"dt_txt":"2021-01-27 12:00:00"},{"dt":1611759600,"main":{"temp":7.82,"feels_like":5.05,"temp_min":7.82,"temp_max":7.82,"pressure":1020,"sea_level":1020,"grnd_level":885,"humidity":44,"temp_kf":0},"weather":[{"id":800,"main":"Clear","description":"clear sky","icon":"01n"}],"clouds":{"all":3},"wind":{"speed":0.44,"deg":244},"visibility":10000,"pop":0,"sys":{"pod":"n"},"dt_txt":"2021-01-27 15:00:00"},{"dt":1611770400,"main":{"temp":6.66,"feels_like":3.68,"temp_min":6.66,"temp_max":6.66,"pressure":1020,"sea_level":1020,"grnd_level":885,"humidity":46,"temp_kf":0},"weather":[{"id":802,"main":"Clouds","description":"scattered clouds","icon":"03n"}],"clouds":{"all":28},"wind":{"speed":0.66,"deg":32},"visibility":10000,"pop":0,"sys":{"pod":"n"},"dt_txt":"2021-01-27 18:00:00"},{"dt":1611781200,"main":{"temp":5.8,"feels_like":2.87,"temp_min":5.8,"temp_max":5.8,"pressure":1019,"sea_level":1019,"grnd_level":884,"humidity":49,"temp_kf":0},"weather":[{"id":800,"main":"Clear","description":"clear sky","icon":"01n"}],"clouds":{"all":1},"wind":{"speed":0.6,"deg":0},"visibility":10000,"pop":0,"sys":{"pod":"n"},"dt_txt":"2021-01-27 21:00:00"},{"dt":1611792000,"main":{"temp":5.53,"feels_like":2.45,"temp_min":5.53,"temp_max":5.53,"pressure":1018,"sea_level":1018,"grnd_level":883,"humidity":49,"temp_kf":0},"weather":[{"id":802,"main":"Clouds","description":"scattered clouds","icon":"03n"}],"clouds":{"all":25},"wind":{"speed":0.78,"deg":336},"visibility":10000,"pop":0,"sys":{"pod":"n"},"dt_txt":"2021-01-28 00:00:00"},{"dt":1611802800,"main":{"temp":5.25,"feels_like":2.26,"temp_min":5.25,"temp_max":5.25,"pressure":1018,"sea_level":1018,"grnd_level":883,"humidity":52,"temp_kf":0},"weather":[{"id":804,"main":"Clouds","description":"overcast clouds","icon":"04n"}],"clouds":{"all":100},"wind":{"speed":0.73,"deg":268},"visibility":10000,"pop":0,"sys":{"pod":"n"},"dt_txt":"2021-01-28 03:00:00"},{"dt":1611813600,"main":{"temp":8.17,"feels_like":5.48,"temp_min":8.17,"temp_max":8.17,"pressure":1018,"sea_level":1018,"grnd_level":884,"humidity":44,"temp_kf":0},"weather":[{"id":804,"main":"Clouds","description":"overcast clouds","icon":"04d"}],"clouds":{"all":100},"wind":{"speed":0.37,"deg":181},"visibility":10000,"pop":0,"sys":{"pod":"d"},"dt_txt":"2021-01-28 06:00:00"},{"dt":1611824400,"main":{"temp":10.82,"feels_like":7.72,"temp_min":10.82,"temp_max":10.82,"pressure":1016,"sea_level":1016,"grnd_level":883,"humidity":39,"temp_kf":0},"weather":[{"id":802,"main":"Clouds","description":"scattered clouds","icon":"03d"}],"clouds":{"all":31},"wind":{"speed":1.09,"deg":167},"visibility":10000,"pop":0,"sys":{"pod":"d"},"dt_txt":"2021-01-28 09:00:00"},{"dt":1611835200,"main":{"temp":12.16,"feels_like":9.01,"temp_min":12.16,"temp_max":12.16,"pressure":1014,"sea_level":1014,"grnd_level":882,"humidity":36,"temp_kf":0},"weather":[{"id":801,"main":"Clouds","description":"few clouds","icon":"02d"}],"clouds":{"all":16},"wind":{"speed":1.18,"deg":159},"visibility":10000,"pop":0,"sys":{"pod":"d"},"dt_txt":"2021-01-28 12:00:00"},{"dt":1611846000,"main":{"temp":10.35,"feels_like":7.28,"temp_min":10.35,"temp_max":10.35,"pressure":1015,"sea_level":1015,"grnd_level":882,"humidity":42,"temp_kf":0},"weather":[{"id":802,"main":"Clouds","description":"scattered clouds","icon":"03n"}],"clouds":{"all":33},"wind":{"speed":1.15,"deg":191},"visibility":10000,"pop":0,"sys":{"pod":"n"},"dt_txt":"2021-01-28 15:00:00"},{"dt":1611856800,"main":{"temp":9.26,"feels_like":6.54,"temp_min":9.26,"temp_max":9.26,"pressure":1016,"sea_level":1016,"grnd_level":882,"humidity":47,"temp_kf":0},"weather":[{"id":803,"main":"Clouds","description":"broken clouds","icon":"04n"}],"clouds":{"all":64},"wind":{"speed":0.76,"deg":268},"visibility":10000,"pop":0.17,"sys":{"pod":"n"},"dt_txt":"2021-01-28 18:00:00"},{"dt":1611867600,"main":{"temp":8.79,"feels_like":6.51,"temp_min":8.79,"temp_max":8.79,"pressure":1016,"sea_level":1016,"grnd_level":882,"humidity":49,"temp_kf":0},"weather":[{"id":804,"main":"Clouds","description":"overcast clouds","icon":"04n"}],"clouds":{"all":91},"wind":{"speed":0.16,"deg":16},"visibility":10000,"pop":0.14,"sys":{"pod":"n"},"dt_txt":"2021-01-28 21:00:00"},{"dt":1611878400,"main":{"temp":8.51,"feels_like":5.49,"temp_min":8.51,"temp_max":8.51,"pressure":1016,"sea_level":1016,"grnd_level":882,"humidity":49,"temp_kf":0},"weather":[{"id":804,"main":"Clouds","description":"overcast clouds","icon":"04n"}],"clouds":{"all":93},"wind":{"speed":1.16,"deg":284},"visibility":10000,"pop":0.17,"sys":{"pod":"n"},"dt_txt":"2021-01-29 00:00:00"},{"dt":1611889200,"main":{"temp":7.71,"feels_like":4.85,"temp_min":7.71,"temp_max":7.71,"pressure":1016,"sea_level":1016,"grnd_level":882,"humidity":52,"temp_kf":0},"weather":[{"id":804,"main":"Clouds","description":"overcast clouds","icon":"04n"}],"clouds":{"all":85},"wind":{"speed":0.94,"deg":322},"visibility":10000,"pop":0,"sys":{"pod":"n"},"dt_txt":"2021-01-29 03:00:00"},{"dt":1611900000,"main":{"temp":10.46,"feels_like":7.6,"temp_min":10.46,"temp_max":10.46,"pressure":1017,"sea_level":1017,"grnd_level":884,"humidity":44,"temp_kf":0},"weather":[{"id":802,"main":"Clouds","description":"scattered clouds","icon":"03d"}],"clouds":{"all":49},"wind":{"speed":0.99,"deg":334},"visibility":10000,"pop":0.03,"sys":{"pod":"d"},"dt_txt":"2021-01-29 06:00:00"},{"dt":1611910800,"main":{"temp":12.7,"feels_like":10.29,"temp_min":12.7,"temp_max":12.7,"pressure":1014,"sea_level":1014,"grnd_level":883,"humidity":37,"temp_kf":0},"weather":[{"id":800,"main":"Clear","description":"clear sky","icon":"01d"}],"clouds":{"all":0},"wind":{"speed":0.29,"deg":216},"visibility":10000,"pop":0.03,"sys":{"pod":"d"},"dt_txt":"2021-01-29 09:00:00"},{"dt":1611921600,"main":{"temp":13.18,"feels_like":9.2,"temp_min":13.18,"temp_max":13.18,"pressure":1013,"sea_level":1013,"grnd_level":882,"humidity":36,"temp_kf":0},"weather":[{"id":801,"main":"Clouds","description":"few clouds","icon":"02d"}],"clouds":{"all":20},"wind":{"speed":2.54,"deg":224},"visibility":10000,"pop":0,"sys":{"pod":"d"},"dt_txt":"2021-01-29 12:00:00"},{"dt":1611932400,"main":{"temp":7.24,"feels_like":2.79,"temp_min":7.24,"temp_max":7.24,"pressure":1015,"sea_level":1015,"grnd_level":881,"humidity":70,"temp_kf":0},"weather":[{"id":500,"main":"Rain","description":"light rain","icon":"10n"}],"clouds":{"all":100},"wind":{"speed":4,"deg":40},"visibility":5544,"pop":0.75,"rain":{"3h":0.26},"sys":{"pod":"n"},"dt_txt":"2021-01-29 15:00:00"},{"dt":1611943200,"main":{"temp":8.66,"feels_like":4,"temp_min":8.66,"temp_max":8.66,"pressure":1015,"sea_level":1015,"grnd_level":881,"humidity":62,"temp_kf":0},"weather":[{"id":501,"main":"Rain","description":"moderate rain","icon":"10n"}],"clouds":{"all":100},"wind":{"speed":4.22,"deg":20},"visibility":10000,"pop":0.76,"rain":{"3h":3.09},"sys":{"pod":"n"},"dt_txt":"2021-01-29 18:00:00"},{"dt":1611954000,"main":{"temp":8.78,"feels_like":5.61,"temp_min":8.78,"temp_max":8.78,"pressure":1013,"sea_level":1013,"grnd_level":880,"humidity":64,"temp_kf":0},"weather":[{"id":500,"main":"Rain","description":"light rain","icon":"10n"}],"clouds":{"all":100},"wind":{"speed":2.22,"deg":61},"visibility":10000,"pop":0.46,"rain":{"3h":0.26},"sys":{"pod":"n"},"dt_txt":"2021-01-29 21:00:00"},{"dt":1611964800,"main":{"temp":8.53,"feels_like":6.22,"temp_min":8.53,"temp_max":8.53,"pressure":1012,"sea_level":1012,"grnd_level":879,"humidity":58,"temp_kf":0},"weather":[{"id":804,"main":"Clouds","description":"overcast clouds","icon":"04n"}],"clouds":{"all":91},"wind":{"speed":0.62,"deg":132},"visibility":10000,"pop":0.42,"sys":{"pod":"n"},"dt_txt":"2021-01-30 00:00:00"},{"dt":1611975600,"main":{"temp":7.56,"feels_like":4.11,"temp_min":7.56,"temp_max":7.56,"pressure":1011,"sea_level":1011,"grnd_level":878,"humidity":58,"temp_kf":0},"weather":[{"id":803,"main":"Clouds","description":"broken clouds","icon":"04n"}],"clouds":{"all":83},"wind":{"speed":2.06,"deg":52},"visibility":10000,"pop":0.5,"sys":{"pod":"n"},"dt_txt":"2021-01-30 03:00:00"},{"dt":1611986400,"main":{"temp":7.95,"feels_like":4.44,"temp_min":7.95,"temp_max":7.95,"pressure":1013,"sea_level":1013,"grnd_level":879,"humidity":55,"temp_kf":0},"weather":[{"id":804,"main":"Clouds","description":"overcast clouds","icon":"04d"}],"clouds":{"all":89},"wind":{"speed":2.07,"deg":139},"visibility":10000,"pop":0.49,"sys":{"pod":"d"},"dt_txt":"2021-01-30 06:00:00"},{"dt":1611997200,"main":{"temp":7.36,"feels_like":3.59,"temp_min":7.36,"temp_max":7.36,"pressure":1012,"sea_level":1012,"grnd_level":878,"humidity":59,"temp_kf":0},"weather":[{"id":804,"main":"Clouds","description":"overcast clouds","icon":"04d"}],"clouds":{"all":97},"wind":{"speed":2.52,"deg":168},"visibility":5917,"pop":0.71,"sys":{"pod":"d"},"dt_txt":"2021-01-30 09:00:00"},{"dt":1612008000,"main":{"temp":8.62,"feels_like":5.84,"temp_min":8.62,"temp_max":8.62,"pressure":1011,"sea_level":1011,"grnd_level":878,"humidity":56,"temp_kf":0},"weather":[{"id":500,"main":"Rain","description":"light rain","icon":"10d"}],"clouds":{"all":89},"wind":{"speed":1.21,"deg":29},"visibility":10000,"pop":0.72,"rain":{"3h":1},"sys":{"pod":"d"},"dt_txt":"2021-01-30 12:00:00"},{"dt":1612018800,"main":{"temp":8.07,"feels_like":4.48,"temp_min":8.07,"temp_max":8.07,"pressure":1012,"sea_level":1012,"grnd_level":879,"humidity":55,"temp_kf":0},"weather":[{"id":801,"main":"Clouds","description":"few clouds","icon":"02n"}],"clouds":{"all":13},"wind":{"speed":2.2,"deg":302},"visibility":10000,"pop":0.3,"sys":{"pod":"n"},"dt_txt":"2021-01-30 15:00:00"},{"dt":1612029600,"main":{"temp":7.16,"feels_like":2.55,"temp_min":7.16,"temp_max":7.16,"pressure":1014,"sea_level":1014,"grnd_level":880,"humidity":55,"temp_kf":0},"weather":[{"id":800,"main":"Clear","description":"clear sky","icon":"01n"}],"clouds":{"all":10},"wind":{"speed":3.49,"deg":335},"visibility":10000,"pop":0.22,"sys":{"pod":"n"},"dt_txt":"2021-01-30 18:00:00"},{"dt":1612040400,"main":{"temp":6.36,"feels_like":1.64,"temp_min":6.36,"temp_max":6.36,"pressure":1013,"sea_level":1013,"grnd_level":879,"humidity":54,"temp_kf":0},"weather":[{"id":802,"main":"Clouds","description":"scattered clouds","icon":"03n"}],"clouds":{"all":31},"wind":{"speed":3.47,"deg":336},"visibility":10000,"pop":0,"sys":{"pod":"n"},"dt_txt":"2021-01-30 21:00:00"},{"dt":1612051200,"main":{"temp":5.9,"feels_like":1.27,"temp_min":5.9,"temp_max":5.9,"pressure":1014,"sea_level":1014,"grnd_level":879,"humidity":56,"temp_kf":0},"weather":[{"id":801,"main":"Clouds","description":"few clouds","icon":"02n"}],"clouds":{"all":15},"wind":{"speed":3.35,"deg":332},"visibility":10000,"pop":0,"sys":{"pod":"n"},"dt_txt":"2021-01-31 00:00:00"},{"dt":1612062000,"main":{"temp":5.18,"feels_like":0.57,"temp_min":5.18,"temp_max":5.18,"pressure":1014,"sea_level":1014,"grnd_level":880,"humidity":61,"temp_kf":0},"weather":[{"id":800,"main":"Clear","description":"clear sky","icon":"01n"}],"clouds":{"all":0},"wind":{"speed":3.41,"deg":321},"visibility":10000,"pop":0,"sys":{"pod":"n"},"dt_txt":"2021-01-31 03:00:00"},{"dt":1612072800,"main":{"temp":7.74,"feels_like":3.26,"temp_min":7.74,"temp_max":7.74,"pressure":1015,"sea_level":1015,"grnd_level":881,"humidity":49,"temp_kf":0},"weather":[{"id":800,"main":"Clear","description":"clear sky","icon":"01d"}],"clouds":{"all":0},"wind":{"speed":3.11,"deg":299},"visibility":10000,"pop":0,"sys":{"pod":"d"},"dt_txt":"2021-01-31 06:00:00"},{"dt":1612083600,"main":{"temp":10.35,"feels_like":5.77,"temp_min":10.35,"temp_max":10.35,"pressure":1013,"sea_level":1013,"grnd_level":880,"humidity":40,"temp_kf":0},"weather":[{"id":800,"main":"Clear","description":"clear sky","icon":"01d"}],"clouds":{"all":0},"wind":{"speed":3.19,"deg":279},"visibility":10000,"pop":0,"sys":{"pod":"d"},"dt_txt":"2021-01-31 09:00:00"},{"dt":1612094400,"main":{"temp":11.53,"feels_like":6,"temp_min":11.53,"temp_max":11.53,"pressure":1013,"sea_level":1013,"grnd_level":881,"humidity":37,"temp_kf":0},"weather":[{"id":800,"main":"Clear","description":"clear sky","icon":"01d"}],"clouds":{"all":0},"wind":{"speed":4.56,"deg":284},"visibility":10000,"pop":0,"sys":{"pod":"d"},"dt_txt":"2021-01-31 12:00:00"},{"dt":1612105200,"main":{"temp":9.46,"feels_like":4.48,"temp_min":9.46,"temp_max":9.46,"pressure":1015,"sea_level":1015,"grnd_level":882,"humidity":43,"temp_kf":0},"weather":[{"id":800,"main":"Clear","description":"clear sky","icon":"01n"}],"clouds":{"all":1},"wind":{"speed":3.8,"deg":311},"visibility":10000,"pop":0,"sys":{"pod":"n"},"dt_txt":"2021-01-31 15:00:00"}],"city":{"id":112931,"name":"Tehran","coord":{"lat":35.6944,"lon":51.4215},"country":"IR","population":7153309,"timezone":12600,"sunrise":1611632313,"sunset":1611669293}}
"""
