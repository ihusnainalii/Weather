//
//  ConnectionError.swift
//  WeatherApp
//
//  Created by Amir on 1/4/21.
//

import UIKit

///Main connection error
public protocol ConnectionError: Error {
    var isInternetConnectionError: Bool { get }
}
/// extend to add a simple bool
public extension Error {
    var isInternetConnectionError: Bool {
        guard let error = self as? ConnectionError, error.isInternetConnectionError else {
            return false
        }
        return true
    }
}
