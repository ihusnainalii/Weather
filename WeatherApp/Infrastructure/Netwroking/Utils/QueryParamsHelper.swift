//
//  QueryParamsHelper.swift
//  WeatherApp
//
//  Created by Amir on 1/20/21.
//

import UIKit

struct QueryParamsHelper
{
    struct Dependency {
        let appConfigurations: AppConfiguration
        
    }
    private let dependency: Dependency
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    /// Default query params
    func defaults() -> [String:String] {
        return [
            "lang":dependency.appConfigurations.apiLocal,
            "appid":dependency.appConfigurations.appId
            ,"units":"metric"
        ]
    }
}
