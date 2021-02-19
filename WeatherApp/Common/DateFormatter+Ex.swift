//
//  DateFormatter+Ex.swift
//  WeatherApp
//
//  Created by Amir on 1/25/21.
//

import Foundation
///Utities to convert date to required formats 
extension Date {
    static func convertTimeIntervalToHourMinutesSeconds(_ timeInterval: TimeInterval) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = LanguageManager.shared.appLocale
        dateFormatter.dateFormat = "hh:mm a"
        let date = convertTimeIntervalToDate(timeInterval)
        return dateFormatter.string(from: date)
    }
    static func convertTimeIntervalToDate(_ timeInterval: TimeInterval) -> Date {
        return Date(timeIntervalSince1970: timeInterval)
    }
    static func convertTimeIntervalToDayOfWeek(_ timeInterval: TimeInterval) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = LanguageManager.shared.appLocale
        dateFormatter.dateFormat = "EEEE"
        let date = convertTimeIntervalToDate(timeInterval)
        return dateFormatter.string(from: date)
    }
    static func convertTimeIntervalToHour(_ timeInterval: TimeInterval) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = LanguageManager.shared.appLocale
        dateFormatter.dateFormat = "hh a"
        let date = convertTimeIntervalToDate(timeInterval)
        return dateFormatter.string(from: date)
    }
    
    var hour: Int {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = LanguageManager.shared.appLocale
            dateFormatter.dateFormat = "HH"
            return Int(dateFormatter.string(from: self)) ?? 0
        }
    }
}
