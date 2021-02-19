//
//  HourlyWeatherCollectionViewCell.swift
//  WeatherApp
//
//  Created by Amir on 1/26/21.
//

import UIKit

final class HourlyWeatherCollectionViewCell: UICollectionViewCell {
    static let identifier = "HourlyWeatherCollectionViewCell" // also enter this string as the cell identifier in the xib
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.image = UIImage.defaultIcon
        timeLabel.text = ""
        temperatureLabel.text = ""
        
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    func config(_ viewModel: WeatherHourItemViewModel) {
        imageView.image = UIImage(viewModel.iconType)
        timeLabel.text = viewModel.hour
        temperatureLabel.text = viewModel.temperature
        temperatureLabel.adjustsFontSizeToFitWidth = true
    }
}
