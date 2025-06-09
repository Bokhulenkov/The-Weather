//
//  DetailWeather.swift
//  The Weather
//
//  Created by Alexander Bokhulenkov on 15.05.2025.
//

import Foundation

struct DetailWeather {
    let day: Int
    let hours: [HourlyWeather]
    let maxTemp: Double
    let minTemp: Double
    let weatherImage: String
    
    init(from dto: Forecastday) {
        self.day = dto.date
        self.maxTemp = dto.day.maxTemp
        self.minTemp = dto.day.minTemp
        self.weatherImage = "https:\(dto.day.condition.icon)"
        self.hours = dto.hour.map {HourlyWeather(from: $0)}
    }
}

struct HourlyWeather {
    let time: Int
    let temp: Double
    let weatherImage: String
    
    init(from hour: Hour) {
        self.time = hour.time
        self.temp = hour.temp
        self.weatherImage = "https:\(hour.condition.icon)"
    }
}

extension WeatherDTO {
    func toDetailWeather() -> [DetailWeather] {
        self.forecast?.forecastday.map { DetailWeather(from: $0)} ?? []
    }
}
