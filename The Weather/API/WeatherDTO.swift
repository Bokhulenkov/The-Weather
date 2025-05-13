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
}

struct Location: Decodable {
    let name: String
    let country: String
    let lat: Double
    let lon: Double
    let localtime_epoch: Int
    let localtime: String
}

struct Current: Decodable {
    let lastUpdatedEpoch: Int
    let lastUpdated: String
    let tempC: Double
    let condition: Condition
    let windKph: Double
    
    enum CodingKeys: String, CodingKey {
        case lastUpdatedEpoch = "last_updated_epoch"
        case lastUpdated = "last_updated"
        case tempC = "temp_c"
        case condition
        case windKph = "wind_kph"
    }
}

struct Condition: Decodable {
    let text, icon: String
    let code: Int
}
