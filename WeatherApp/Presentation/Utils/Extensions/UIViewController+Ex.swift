//
//  UIViewController.swift
//  WeatherApp
//
//  Created by aakpro on 01.10.18.
//


import UIKit
extension UIViewController {
    func showErrorAlert(_ errorMessage: String, title: String = LocalizedValue(.error), retryAction: (() -> Void)? = nil, preferredStyle: UIAlertController.Style = .alert) {
        let alert = UIAlertController(title: title, message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: LocalizedValue(.OK), style: .cancel, handler: nil))
        if let retry = retryAction {
            alert.addAction(UIAlertAction(title: LocalizedValue(.retry), style: .default, handler: { _ in retry()}))
        }
        self.present(alert, animated: true)
    }
}

