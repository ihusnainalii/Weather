//
//  SettingsViewController.swift
//  WeatherApp
//
//  Created by Amir on 1/24/21.
//

import UIKit

final class SettingsViewController: UIViewController, StoryboardInstantiable
{
    fileprivate var viewModel: SettingsViewModel!
    //MARK: - Static Factory Initializer
    static func create(with viewModel: SettingsViewModel) -> SettingsViewController {
        let vc = SettingsViewController.instantiateViewController()
        vc.viewModel = viewModel
        return vc
    }
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = LocalizedValue(.settingTitle)
        bind()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    // MARK: - IBOutlets
    @IBOutlet weak var locationsTableView: UITableView!{
        didSet {
            locationsTableView.removeExtraCells()
            locationsTableView.register(UINib(nibName: SettingsTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: SettingsTableViewCell.identifier)
            locationsTableView.delegate = self
            locationsTableView.dataSource = self
            locationsTableView.reloadData()
        }
    }
    @IBOutlet weak var addLocationButton: UIButton! {
        didSet {
            addLocationButton.addAction(UIAction(handler: { [weak self] _ in
                self?.viewModel.navigateToAddLocation()
            }), for: .touchUpInside)
        }
    }
    //MARK: - Setup
    func bind() {
        viewModel.items.observe(on: self) { [weak self] _ in
            DispatchQueue.main.async {
                self?.locationsTableView?.reloadData()
            }
        }
        viewModel.errorMessage.observe(on: self) { [weak self] message in
            guard let m = message else { return }
            DispatchQueue.main.async {
                self?.showErrorAlert(m)
            }
        }
    }
}

extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.item(at: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.identifier, for: indexPath) as! SettingsTableViewCell
        cell.config(item)
        return cell
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            viewModel.deleteItem(at: indexPath.row)
        }
    }
}
