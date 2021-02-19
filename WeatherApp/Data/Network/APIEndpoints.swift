//
//  APIEndpoints.swift
//  WeatherApp
//
//  Created by Amir on 1/2/21.
//

import Foundation
///All the app api endpoints
struct APIEndpoints {
    static func fetchWetherDataOfCity(_ city: String) -> Endpoint<WeatherData> {
        return Endpoint(path: "/find", isFullPath: false, method: .get, headerParamaters: [:], queryParametersEncodable: nil, queryParameters: ["q":city])
    }
    static func fetchWetherForecastDataOfCity(_ city: String) -> Endpoint<WeatherData> {
        return Endpoint(path: "/forecast", isFullPath: false, method: .get, headerParamaters: [:], queryParametersEncodable: nil, queryParameters: ["q":city])
    }
}
