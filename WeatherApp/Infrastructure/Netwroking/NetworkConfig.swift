//
//  NetworkConfig.swift
//  WeatherApp
//
//  Created by Amir on 1/2/21.
//

import Foundation
///Required default configuration for data transfer service
public protocol NetworkConfigurable {
    var baseURL: URL { get }
    var rootOfEndpoint: String { get }
    var version: String { get }
    var headers: [String: String] { get }
    var queryParameters: [String: String] { get }
}

public struct ApiDataNetworkConfig: NetworkConfigurable {
    public let rootOfEndpoint: String
    public let version: String
    public let baseURL: URL
    public let headers: [String: String]
    public let queryParameters: [String: String]
    
     public init(baseURL: URL,
                 rootOfUrl: String = "data",
                 version: String = "v1",
                 headers: [String: String] = [:],
                 queryParameters: [String: String] = [:]) {
        self.baseURL = baseURL
        self.headers = headers
        self.queryParameters = queryParameters
        self.rootOfEndpoint = rootOfUrl
        self.version = version
    }
}
