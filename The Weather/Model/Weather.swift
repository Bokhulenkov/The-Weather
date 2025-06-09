//
//  Weather.swift
//  The Weather
//
//  Created by Alexander Bokhulenkov on 14.05.2025.
//

import Foundation

struct Weather {
    let city: String
    let tempC: Double
    let condition: String
    let weatherImage: String
    
    init(from dto: WeatherDTO) {
        self.city = dto.location.name
        self.tempC = dto.current.tempC
        self.condition = dto.current.condition.text
        self.weatherImage = "https:\(dto.current.condition.icon)" 
    }
}
    
