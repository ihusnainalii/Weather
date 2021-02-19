//
//  RepositoryTask.swift
//  WeatherApp
//
//  Created by Amir on 1/2/21.
//

import UIKit
///Repository task is also cancellable with extra feature to work easily when using repositories
class RepositoryTask: Cancellable {
    var networkTask: NetworkCancellable?
    var isCancelled: Bool = false
    
    func cancel() {
        networkTask?.cancel()
        isCancelled = true
    }
}
