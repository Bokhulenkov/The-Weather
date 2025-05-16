//
//  WeatherDTO.swift
//  The Weather
//
//  Created by Alexander Bokhulenkov on 13.05.2025.
//

import Foundation

struct WeatherDTO: Decodable {
    let location: Location
    let current: Current
    let forecast: Forecast?
}

struct Location: Decodable {
    let name: String
//    let country: String
//    let lat: Double
//    let lon: Double
//    let localtime_epoch: Int
//    let localtime: String
}

struct Current: Decodable {
    let tempC: Double
    let condition: Condition
    
    enum CodingKeys: String, CodingKey {
        case tempC = "temp_c"
        case condition
    }
}

struct Condition: Decodable {
    let text, icon: String
//    let code: Int
}

struct Forecast: Decodable {
    let forecastday: [Forecastday]
}

struct Forecastday: Decodable {
    let date: Int
    let day: Day
    let hour: [Hour]
    
    enum CodingKeys: String, CodingKey {
        case date = "date_epoch"
        case day
        case hour
    }
}

struct Day: Decodable {
    let maxTemp: Double
    let minTemp: Double
    let condition: Condition
    
    enum CodingKeys: String, CodingKey {
        case maxTemp = "maxtemp_c"
        case minTemp = "mintemp_c"
        case condition
    }
}

struct Hour: Decodable {
    let time: Int
    let temp: Double
    let condition: Condition
    
    enum CodingKeys: String, CodingKey {
        case time = "time_epoch"
        case temp = "temp_c"
        case condition
    }
}
