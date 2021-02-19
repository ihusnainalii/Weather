//
//  NetworkConfigurableMock.swift
//  WeatherAppTests
//
//  Created by Amir on 1/26/21.
//

import Foundation
import WeatherApp

class NetworkConfigurableMock: NetworkConfigurable {
    var rootOfEndpoint: String = ""
    
    var version: String = ""
    
    var baseURL: URL = URL(string: "https://google.com")!
    var headers: [String: String] = [:]
    var queryParameters: [String: String] = [:]
}
