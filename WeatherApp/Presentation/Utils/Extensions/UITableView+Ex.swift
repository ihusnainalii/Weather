//
//  UITableView+Ex.swift
//  WeatherApp
//
//  Created by Amir on 1/24/21.
//

import UIKit

extension UITableView
{
    func removeExtraCells() {
        self.tableFooterView = UIView(frame: .zero)
    }
}
