//
//  WeatherEndpoint.swift
//  The Weather
//
//  Created by Alexander Bokhulenkov on 13.05.2025.
//

import Foundation

public enum WeatherEndpoint {
    case current (location: String)
    case days (Int, location: String)
    
    func path() -> String {
        switch self {
        case .current:
            return "/v1/current.json"
        case .days:
            return "/v1/forecast.json"
        }
    }
    
    func quaryItems(key: String) -> [URLQueryItem] {
        switch self {
        case .current(let location):
            return [
                URLQueryItem(name: "key", value: key),
                URLQueryItem(name: "q", value: location)
            ]
        case .days(let days, let location):
            return [
                URLQueryItem(name: "key", value: key),
                URLQueryItem(name: "q", value: location),
                URLQueryItem(name: "days", value: "\(days)")
            ]
        }
    }
    
    func url(baseURL: URL, key: String) -> URL {
        var components = URLComponents()
        components.scheme = baseURL.scheme
        components.host = baseURL.host
        components.path = path()
        components.queryItems = quaryItems(key: key)
        
        guard let url = components.url else {
            fatalError("Invalid url components \(components.debugDescription)")
        }
        
        return url
    }
}

// api.weatherapi.com/v1/forecast.json?key=fa8b3df74d4042b9aa7135114252304&q=LAT,LON&days=7
// api.weatherapi.com/v1/current.json?key=fa8b3df74d4042b9aa7135114252304&q=LAT,LON

