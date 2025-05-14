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
//    let lastUpdatedEpoch: Int
//    let lastUpdated: String
    let tempC: Double
    let condition: Condition
//    let windKph: Double
    
    enum CodingKeys: String, CodingKey {
//        case lastUpdatedEpoch = "last_updated_epoch"
//        case lastUpdated = "last_updated"
        case tempC = "temp_c"
        case condition
//        case windKph = "wind_kph"
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
    let date: String
    let dateEpoch: Int
    let day: Day
    let hour: Hour
    let condition: Condition
    
    enum CodingKeys: String, CodingKey {
        case date
        case dateEpoch = "date_epoch"
        case day
        case hour
        case condition
    }
}

struct Day: Decodable {
    let maxTemp: Double
    let minTemp: Double
    let avgTemp: Double
    let condition: Condition
    
    enum CodingKeys: String, CodingKey {
        case maxTemp = "maxtemp_c"
        case minTemp = "mintemp_c"
        case avgTemp = "avgtemp_c"
        case condition
    }
}

struct Hour: Decodable {
    let timeEpoch: Int
    let time: String
    let temp: Double
    let condition: Condition
    
    enum CodingKeys: String, CodingKey {
        case timeEpoch = "time_epoch"
        case time
        case temp = "temp_c"
        case condition
    }
}
