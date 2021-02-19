//
//  WeatherIcons.swift
//  WeatherApp
//
//  Created by Amir on 1/25/21.
//

import UIKit
///Converter of open weather apis to sfSymbols
enum WeatherIcons: String, Codable {
    case clearDay = "01d"
    case clearNight = "01n"
    case fewCloudyDay = "02d"
    case fewCloudyNight = "02n"
    case scatteredCloudsDay = "03d"
    case scatteredCloudsNight = "03n"
    case brokenCloudsDay = "04d"
    case brokenCloudsNight = "04n"
    case showerRainDay = "09d"
    case showerRainNight = "09n"
    case rainDay = "10d"
    case rainNight = "10n"
    case thunderstormDay = "11d"
    case thunderstormNight = "11n"
    case snowDay = "13d"
    case snowNight = "13n"
    case mistDay = "50d"
    case mistNight = "50n"
    case unexpectedType = "default"
    
    var sfSymbol: SFSymbol {
        var symbol = SFSymbol.circle
        switch self {
        case .clearDay:
            symbol = .sunMin
        case .clearNight:
            symbol = .moon
        case .fewCloudyDay:
            symbol = .cloudSun
        case .fewCloudyNight:
            symbol = .cloudMoon
        case .unexpectedType:
            symbol = .thermometer
        case .scatteredCloudsDay:
            symbol = .cloud
        case .scatteredCloudsNight:
            symbol = .cloud
        case .brokenCloudsDay:
            symbol = .smoke
        case .brokenCloudsNight:
            symbol = .smokeFill
        case .showerRainDay:
            symbol = .cloudHeavyrain
        case .showerRainNight:
            symbol = .cloudHeavyrainFill
        case .rainDay:
            symbol = .cloudSunRain
        case .rainNight:
            symbol = .cloudMoonRain
        case .thunderstormDay:
            symbol = .cloudSunRain
        case .thunderstormNight:
            symbol = .cloudMoonRain
        case .snowDay:
            symbol = .snow
        case .snowNight:
            symbol = .snow
        case .mistDay:
            symbol = .cloudFog
        case .mistNight:
            symbol = .cloudFogFill
        }
        return symbol
    }
}
