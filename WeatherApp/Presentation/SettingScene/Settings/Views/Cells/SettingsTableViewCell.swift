//
//  SettingsTableViewCell.swift
//  WeatherApp
//
//  Created by Amir on 1/24/21.
//

import UIKit

final class SettingsTableViewCell: UITableViewCell
{
    static let identifier = "SettingsTableViewCell"

    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherConditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cityNameLabel.text = ""
        temperatureLabel.text = ""
        weatherConditionImageView.image = UIImage(.sunMin)
    }
    
    func config(_ item: SettingItemViewModel) {
        cityNameLabel.text = item.cityName
        temperatureLabel.text = item.temperature
        weatherConditionImageView.image = UIImage(item.icon)
    }
}
