//
//  DateExtensions.swift
//  The Weather
//
//  Created by Alexander Bokhulenkov on 15.05.2025.
//

import Foundation

extension Date {
    static func weekday(from timestamp: Int, locale: Locale =  Locale(identifier: "en_US")) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let dateFormater = DateFormatter()
        dateFormater.locale = locale
        dateFormater.dateFormat = "EEE"
        let weekday = dateFormater.string(from: date)
        return weekday
    }
    
    static func formattedTime(from timestamp: Int, format: String = "HH") -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = TimeZone.current
        let hour = formatter.string(from: date)
        return hour
    }
    
    static var currentHourTimestamp: Int {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.year, .month, .day, .hour], from: now)
        guard let hourStartDate = calendar.date(from: components) else {
            fatalError("Error create hourStartDate")
        }
        return Int(hourStartDate.timeIntervalSince1970)
    }
}
