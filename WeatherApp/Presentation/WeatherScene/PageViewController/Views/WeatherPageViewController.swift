//
//  WeatherPageViewController.swift
//  WeatherApp
//
//  Created by Amir on 1/17/21.
//

import UIKit

final class WeatherPageViewController: UIViewController, StoryboardInstantiable
{
    var viewModel: WeatherPageViewModel!
    //MARK: - Static Factory Builder
    static func createViewController(with viewModel: WeatherPageViewModel) -> WeatherPageViewController {
        let vc = WeatherPageViewController.instantiateViewController()
        vc.viewModel = viewModel
        return vc
    }
    //MARK: - Outlets
    
    // Track the current index
    fileprivate var currentIndex: Int?
    fileprivate var pendingIndex: Int?
    
    // The custom UIPageControl
    @IBOutlet weak var locationPageControl: UIPageControl!
    // Setting Button and its action
    @IBOutlet weak var settingButton: UIButton! {
        didSet {
            settingButton.addAction(UIAction(handler: { [weak self] (action) in
                self?.viewModel.showSettings()
            }), for: .touchUpInside)
        }
    }
    // The UIPageViewController
    var pageViewController: UIPageViewController!
    // The pages it contains
    var weatherViewControllers = [UIViewController]()
    //MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    //MARK: - Setup
    private func bind() {
        viewModel.cities.observe(on: self) {[weak self] _ in
            if self?.pageViewController == nil { self?.setupPageViewController() }
            self?.updateViewControllers()
        }
        viewModel.errorMessage.observe(on: self) {[weak self] (message) in
            guard let message = message else { return }
            self?.showErrorAlert(message, title: LocalizedValue(.error)) {
                self?.viewModel.retry()
            }
        }
    }
    private func setupViews() {
        self.navigationItem.title = " "
    }
}

extension WeatherPageViewController: UIPageViewControllerDataSource {
    
    func updateViewControllers() {
        DispatchQueue.main.async {
            self.weatherViewControllers = self.viewModel.createWeatherViewControllers() ?? []
            self.pageViewController.setViewControllers([self.weatherViewControllers.first ?? UIViewController()], direction: .forward, animated: false, completion: nil)
            self.locationPageControl.numberOfPages = self.weatherViewControllers.count
        }
    }
    
    func setupPageViewController() {
        // Create the page container
        DispatchQueue.main.async {
            self.pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
            self.pageViewController.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 85)
            self.pageViewController.delegate = self
            self.pageViewController.dataSource = self
            self.addChild(self.pageViewController)
            self.view.addSubview(self.pageViewController.view)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = weatherViewControllers.firstIndex(of: viewController) else { return nil }
        let previousIndex = viewControllerIndex - 1
        guard weatherViewControllers.count > previousIndex &&  previousIndex >= 0 else { return nil }
        return weatherViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        guard let viewControllerIndex = weatherViewControllers.firstIndex(of: viewController) else { return nil }
        let nextIndex = viewControllerIndex + 1
        guard weatherViewControllers.count > nextIndex else { return nil }
        return weatherViewControllers[nextIndex]
    }
}

extension WeatherPageViewController: UIPageViewControllerDelegate {
   
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        guard let vc = pendingViewControllers.first else { return  }
        pendingIndex = self.weatherViewControllers.firstIndex(of: vc)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            currentIndex = pendingIndex
            if let index = currentIndex {
                locationPageControl.currentPage = index
            }
        }
    }
}
