//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Amir on 1/17/21.
//

import UIKit

final class WeatherViewController: UIViewController, StoryboardInstantiable
{
    fileprivate var viewModel: WeatherViewModel!
    private var refreshControl = UIRefreshControl()
    //MARK: - Static Factory Initializer
    static func create(with viewModel: WeatherViewModel) -> WeatherViewController {
        let vc = WeatherViewController.instantiateViewController()
        vc.viewModel = viewModel
        return vc
    }
    // MARK: - IBOutlets
    
    // VC Outlets
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.refreshControl = refreshControl
        }
    }
    
    // Top View
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var currentWeatherIcon: UIImageView!
    @IBOutlet weak var currentSummaryLabel: UILabel!
    @IBOutlet weak var currentLocationLabel: UILabel!
    
    // Hourly Middle View
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var hourlyWeatherCollectionView: UICollectionView! {
        didSet {
            hourlyWeatherCollectionView.register(UINib(nibName: HourlyWeatherCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: HourlyWeatherCollectionViewCell.identifier)
        }
    }
    @IBOutlet weak var dailyHighTempLabel: UILabel!
    @IBOutlet weak var dailyLowTempLabel: UILabel!
    
    // Daily Weather Table View
    @IBOutlet weak var dailyWeatherTableView: UITableView! {
        didSet {
            dailyWeatherTableView.removeExtraCells()
            dailyWeatherTableView.register(UINib(nibName: DailyWeatherTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: DailyWeatherTableViewCell.identifier)
        }
    }
    
    // Lower Detail View
    
    @IBOutlet weak var apparentTemperatureTitleLabel: UILabel!
    @IBOutlet weak var apparentTemperatureValueLabel: UILabel!
    @IBOutlet weak var rainTitleLabel: UILabel!
    @IBOutlet weak var rainValueLabel: UILabel!
    @IBOutlet weak var windTitleLabel: UILabel!
    @IBOutlet weak var windValueLabel: UILabel!
    @IBOutlet weak var humidityTitleLabel: UILabel!
    @IBOutlet weak var humidityValueLabel: UILabel!
    @IBOutlet weak var sunriseTitleLabel: UILabel!
    @IBOutlet weak var sunriseValueLabel: UILabel!
    @IBOutlet weak var sunsetTitleLabel: UILabel!
    @IBOutlet weak var sunsetValueLabel: UILabel!
    @IBOutlet weak var cloudCoverTitleLabel: UILabel!
    @IBOutlet weak var cloudCoverValueLabel: UILabel!
    @IBOutlet weak var visibilityTitleLabel: UILabel!
    @IBOutlet weak var visibilityValueLabel: UILabel!
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeView()
        bind()
    }
    func bind() {
        viewModel.weatherData.observe(on: self) { [weak self] _ in
            DispatchQueue.main.async {
                self?.loadData()
            }
        }
        viewModel.days.observe(on: self) { [weak self] _ in
            DispatchQueue.main.async {
                self?.dailyWeatherTableView.reloadData()}
        }
        viewModel.hours.observe(on: self) { [weak self] _ in self?.hourlyWeatherCollectionView.reloadData() }
        viewModel.errorMessage.observe(on: self) { [weak self] (message) in
            guard let message = message else { return }
            self?.showErrorAlert(message, title: LocalizedValue(.error)) {
                self?.viewModel.refreshData()
            }
        }
        viewModel.isLoading.observe(on: self) {[weak self](isLoading) in
            if isLoading {
                LoadingView.show()
            } else {
                LoadingView.hide();
                self?.refreshControl.endRefreshing()
            }
        }
    }
    
    @objc private func refreshData() {
        viewModel.refreshData()
    }
    
    // MARK: - Display Methods
    
    private func initializeView() {
        refreshControl.tintColor = .defaultColor
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)

        currentLocationLabel.text = viewModel.cityName
        currentTemperatureLabel.text = "--"
        currentSummaryLabel.text = ""
        rainTitleLabel.isHidden = true
        rainValueLabel.isHidden = true
        currentWeatherIcon.image = UIImage.defaultIcon
        dailyHighTempLabel.isHidden = true
        dailyLowTempLabel.isHidden = true
        apparentTemperatureTitleLabel.isHidden = true
        apparentTemperatureValueLabel.isHidden = true
        windTitleLabel.isHidden = true
        windValueLabel.isHidden = true
        humidityTitleLabel.isHidden = true
        humidityValueLabel.isHidden = true
        sunriseTitleLabel.isHidden = true
        sunriseValueLabel.isHidden = true
        sunsetTitleLabel.isHidden = true
        sunsetValueLabel.isHidden = true
        cloudCoverTitleLabel.isHidden = true
        cloudCoverValueLabel.isHidden = true
        visibilityTitleLabel.isHidden = true
        visibilityValueLabel.isHidden = true
    }
    private func loadData() {
        dayLabel.text = Date.convertTimeIntervalToDayOfWeek(Date().timeIntervalSince1970)
        currentTemperatureLabel.text = viewModel.temperature
        apparentTemperatureValueLabel.text = viewModel.apparentTemperature
        rainValueLabel.text = viewModel.rain
        rainTitleLabel.text = viewModel.rainTitle
        windValueLabel.text = viewModel.windSpeed
        sunriseValueLabel.text = viewModel.sunriseTime
        sunsetValueLabel.text = viewModel.sunsetTime
        cloudCoverValueLabel.text = viewModel.cloudCover
        visibilityValueLabel.text = viewModel.visibility
        humidityValueLabel.text = viewModel.humidity
        currentSummaryLabel.text = viewModel.summary
        currentWeatherIcon.image = UIImage(viewModel.icon)
        currentLocationLabel.text = viewModel.cityName
        dailyHighTempLabel.text = viewModel.maxTemperature
        dailyLowTempLabel.text = viewModel.minTemperature
        
        currentWeatherIcon.isHidden = false
        rainTitleLabel.isHidden = false
        rainValueLabel.isHidden = false
        apparentTemperatureTitleLabel.isHidden = false
        apparentTemperatureValueLabel.isHidden = false
        windTitleLabel.isHidden = false
        windValueLabel.isHidden = false
        humidityTitleLabel.isHidden = false
        humidityValueLabel.isHidden = false
        sunriseTitleLabel.isHidden = false
        sunriseValueLabel.isHidden = false
        sunsetTitleLabel.isHidden = false
        sunsetValueLabel.isHidden = false
        cloudCoverTitleLabel.isHidden = false
        cloudCoverValueLabel.isHidden = false
        visibilityTitleLabel.isHidden = false
        visibilityValueLabel.isHidden = false
        dayLabel.isHidden = false
        todayLabel.isHidden = false
        dailyHighTempLabel.isHidden = false
        dailyLowTempLabel.isHidden = false
        
    }
}


extension WeatherViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.hours.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyWeatherCollectionViewCell.identifier, for: indexPath) as! HourlyWeatherCollectionViewCell
        cell.config(viewModel.hours.value[indexPath.row])
        return cell
    }
}

extension WeatherViewController: UITableViewDataSource, UITableViewDelegate {
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.days.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.dailyWeatherTableView.dequeueReusableCell(withIdentifier: DailyWeatherTableViewCell.identifier) as! DailyWeatherTableViewCell
        cell.config(viewModel.days.value[indexPath.row])
        return cell
    }
    
}

