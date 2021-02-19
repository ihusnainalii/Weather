//
//  DailyWeatherTableViewCell.swift
//  WeatherApp
//
//  Created by Amir on 1/26/21.
//

import UIKit

final class DailyWeatherTableViewCell: UITableViewCell {
    static let identifier = "DailyWeatherTableViewCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        dailyWeatherIcon.image = UIImage.defaultIcon
        dayOfTheWeekLabel.text = ""
        dailyTableViewLowTempLabel.text = ""
        dailyTableViewHighTempLabel.text = ""
        
    }
    @IBOutlet weak var dayOfTheWeekLabel: UILabel!
    @IBOutlet weak var dailyWeatherIcon: UIImageView!
    @IBOutlet weak var dailyTableViewLowTempLabel: UILabel!
    @IBOutlet weak var dailyTableViewHighTempLabel: UILabel!
    func config(_ viewModel: WeatherDayItemViewModel) {
        dailyWeatherIcon.image = UIImage(viewModel.iconType)
        dayOfTheWeekLabel.text = viewModel.dayOfTheWeek
        dailyTableViewLowTempLabel.text = viewModel.minTeperature
        dailyTableViewHighTempLabel.text = viewModel.maxTeperature
    }
}
