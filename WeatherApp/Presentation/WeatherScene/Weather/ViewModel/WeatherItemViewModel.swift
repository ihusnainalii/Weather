//
//  WeatherHourItemViewModel.swift
//  WeatherApp
//
//  Created by Amir on 1/25/21.
//
import Foundation
protocol WeatherDayItemViewModelInput {
    var list: List { get }
}

protocol WeatherDayItemViewModelOutput {
    var iconType: WeatherIcons { get }
    var dayOfTheWeek: String? { get }
    var minTeperature: String? { get }
    var maxTeperature: String? { get }
}

protocol WeatherDayItemViewModel: WeatherDayItemViewModelInput, WeatherDayItemViewModelOutput {
    func isInTheSameDay(with item: WeatherDayItemViewModel) -> Bool
    var date: Date { get }
}

final class DefaultWeatherDayItemViewModel: WeatherDayItemViewModel
{
    func isInTheSameDay(with item: WeatherDayItemViewModel) -> Bool {
        Calendar.current.isDate(self.date, inSameDayAs:item.date)
    }
    var iconType: WeatherIcons {
        guard let name = list.weather?.first?.icon else { return .unexpectedType }
        return WeatherIcons(rawValue: name) ?? .unexpectedType
    }
    
    var dayOfTheWeek: String? {
        guard let ti = list.dt else { return nil }
        return Date.convertTimeIntervalToDayOfWeek(TimeInterval(ti))
    }
    
    var minTeperature: String? {
        return list.main?.minTempString 
    }
    
    var maxTeperature: String? {
        return list.main?.maxTempString
    }
    
    var date: Date {
        guard let ti = list.dt else { return Date() }
        return Date.convertTimeIntervalToDate(TimeInterval(ti))
    }
    
    
    let list: List
    
    init(list: List) {
        self.list = list
    }
}

protocol WeatherHourItemViewModelInput {
    var list: List { get }
}

protocol WeatherHourItemViewModelOutput {
    var hour: String? { get }
    var iconType: WeatherIcons { get }
    var temperature: String? { get }
}

protocol WeatherHourItemViewModel: WeatherHourItemViewModelInput, WeatherHourItemViewModelOutput { }



final class DefaultWeatherHourItemViewModel: WeatherHourItemViewModel
{
    var hour: String? {
        guard let ti = list.dt else { return nil }
        return Date.convertTimeIntervalToHour(TimeInterval(ti))
    }
    
    var iconType: WeatherIcons {
        guard let name = list.weather?.first?.icon else { return .unexpectedType }
        return WeatherIcons(rawValue: name) ?? .unexpectedType
    }

    var temperature: String? {
        return list.main?.tempString
    }
    
    let list: List
    
    init(list: List) {
        self.list = list
    }
}
