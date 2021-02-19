//
//  ChooseLocationViewModel.swift
//  WeatherApp
//
//  Created by Amir on 1/24/21.
//

import UIKit
import CoreLocation

struct LocationViewModelActions {
    let back: (() -> Void)
}
protocol ChooseLocationInputViewModel {
    func searched(_ searchTerm: String)
    func pressedBackButton()
    func selectedResult(at index: Int) 
}

protocol ChooseLocationOutputViewModel {
    var count: Int { get }
    var searchResults: Observable<[String]> { get }
}

protocol ChooseLocationViewModel: ChooseLocationOutputViewModel, ChooseLocationInputViewModel{ }

final class DefaultChooseLocationViewModel: ChooseLocationViewModel
{
    var errorMessage = Observable<String?>(.none)
    var count: Int {
        return searchResults.value.count
    }
    
    var searchResults = Observable<[String]>([]) 
    lazy var geocoder = CLGeocoder()
    
    struct Dependency {
        let actions: LocationViewModelActions
        let useCase: SaveUserCityUseCase
    }
    fileprivate let dependency: Dependency
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    func searched(_ searchTerm: String) {
        geocoder.geocodeAddressString(searchTerm) { [weak self] (placemakers, error) in
            if let err = error {
                printIfDebug(err.localizedDescription)
                return
            }
            guard let places = placemakers else { return }
            self?.searchResults.value = places.compactMap { $0.locality }
        }
    }
    
    func pressedBackButton() {
        dependency.actions.back()
    }

    func selectedResult(at index: Int) {
        let city = searchResults.value[index]
        dependency.useCase.execute(city: city) { _ in }
        dependency.actions.back()
    }
}

