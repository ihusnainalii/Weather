//
//  Cancellable.swift
//  WeatherApp
//
//  Created by Amir on 1/2/21.
//

import Foundation
/// Required for async task cancellation
public protocol Cancellable {
    func cancel()
}
