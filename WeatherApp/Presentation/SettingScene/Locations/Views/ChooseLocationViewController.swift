//
//  ChooseLocationViewController.swift
//  WeatherApp
//
//  Created by Amir on 1/17/21.
//

import UIKit

final class ChooseLocationViewController: UIViewController, StoryboardInstantiable
{
    fileprivate var viewModel: ChooseLocationViewModel!
    //MARK: - Static Factory Initializer
    static func create(with viewModel: ChooseLocationViewModel) -> ChooseLocationViewController {
        let vc = ChooseLocationViewController.instantiateViewController()
        vc.viewModel = viewModel
        return vc
    }
    //MARK: - IBOutlet
    @IBOutlet weak var backButton: UIButton! {
        didSet {
            backButton.addAction(UIAction(handler: { [weak self] (action) in
                self?.viewModel.pressedBackButton()
            }), for: .touchUpInside)
        }
    }
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet{
            searchBar.delegate = self
            searchBar.sizeToFit()
            self.definesPresentationContext = true
            searchBar.becomeFirstResponder()
        }
    }
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.removeExtraCells()
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    //MARK: - Setup
    func bind() {
        viewModel.searchResults.observe(on: self) { [weak self] _ in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        bind()
    }
}
extension ChooseLocationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let name = viewModel.searchResults.value[indexPath.row]
        cell.textLabel?.textColor = .textColor
        cell.textLabel?.text =  name
        return cell
    }
}
extension ChooseLocationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectedResult(at: indexPath.row)
    }
}

extension ChooseLocationViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searched(searchText)
    }
}
