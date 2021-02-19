// WeatherPageViewModel.swift
// WeatherApp
//
// Created by Amir on 1/17/21.
//
//
import CoreLocation

struct WeatherPageViewModelActions {
    let createWeatherViewControllers:(_ cityNames: [String]) -> [WeatherViewController]
    let showSettingView: () -> Void
    let showChooseLocationView: () -> Void
}

protocol WeatherPageViewModelInput {
    func viewWillAppear()
    func showSettings()
    func showLocationView()
    func createWeatherViewControllers() -> [WeatherViewController]?
    func retry()
}

protocol WeatherPageViewModelOutput {
    var cities: Observable<[String]?> { get }
    var numberOfCities: Int { get }
    var errorMessage: Observable<String?> { get }
}

protocol WeatherPageViewModel: WeatherPageViewModelOutput, WeatherPageViewModelInput{ }

final class DefaultWeatherPageViewModel: NSObject, WeatherPageViewModel
{
    var errorMessage: Observable<String?> = Observable(.none)
    func createWeatherViewControllers() -> [WeatherViewController]? {
        guard let cities = cities.value else { return nil }
        return dependency.actions.createWeatherViewControllers(cities)
    }
    let cities = Observable<[String]?>(.none)
    
     var numberOfCities: Int {
        get { return cities.value?.count ?? 0 }
    }
    
    private var isLocationEnabled: Bool {
        get { dependency.locationManager.isLocationEnabled() }
    }
    
    struct Dependency {
        let fetchUseCase: FetchUserCitiesUseCase
        let locationManager: LocationManager
        let actions: WeatherPageViewModelActions
    }
    private let dependency: Dependency
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    func fetchCities() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            let fetchGroup = DispatchGroup()
            fetchGroup.enter()
            self?.fetchSavedCities { fetchGroup.leave() }
            fetchGroup.wait()
            if let locationEnabled = self?.isLocationEnabled, locationEnabled == true {
                fetchGroup.enter()
                self?.getLocation { fetchGroup.leave() }
                fetchGroup.wait()
                
            }
            DispatchQueue.main.async {
                if self?.numberOfCities == 0 {
                    self?.showLocationView()
                }
            }
        }
    }
    
    private func fetchSavedCities(completion: (() -> Void)? = nil) {
        dependency.fetchUseCase.execute { [weak self] (result) in
            switch result {
            case .success(let cities):
                guard self?.areCitiesTheSame(cities1: cities, cities2: self?.cities.value) == false else { completion?(); return }
                self?.cities.value = cities
            case .failure(let error):
                self?.handleError(error)
            }
            completion?()
        }
    }
    ///If user give permission to app the location of user will be added to view controllers
    private func getLocation(completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            self.dependency.locationManager.getCurrentReverseGeoCodedLocation { [weak self] (coordination, placeMarker, error) in
                guard let cityName = placeMarker?.locality else { completion?(); return }
                guard  let t = self?.cities.value?.contains(cityName), t == false else { completion?(); return }
                self?.cities.value?.insert(cityName, at: 0)
                completion?()
            }
        }
    }
    func handleError(_ error: Error) {
        errorMessage.value = error.localizedDescription
    }
    
    private func areCitiesTheSame(cities1: [String]?, cities2: [String]?) -> Bool {
        let cities1Set = Set(arrayLiteral: cities1)
        let cities2Set = Set(arrayLiteral: cities2)
        return cities1Set == cities2Set
    }
}

extension DefaultWeatherPageViewModel {
    
    func viewWillAppear() {
        fetchCities()
    }
    func showSettings() {
        dependency.actions.showSettingView()
    }
    func retry() {
        fetchCities()
    }
    func showLocationView() {
        dependency.actions.showChooseLocationView()
    }
}
