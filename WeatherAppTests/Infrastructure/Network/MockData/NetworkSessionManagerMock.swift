//
//  NetworkSessionManagerMock.swift
//  WeatherAppTests
//
//  Created by Amir on 1/26/21.
//

import Foundation
import WeatherApp

struct NetworkSessionManagerMock: NetworkSessionManager {
    let response: HTTPURLResponse?
    let data: Data?
    let error: Error?
    
    func request(_ request: URLRequest,
                 completion: @escaping CompletionHandler) -> NetworkCancellable {
        completion(data, response, error)
        return URLSessionDataTask()
    }
}
