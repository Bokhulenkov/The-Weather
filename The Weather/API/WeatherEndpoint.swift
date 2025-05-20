//
//  WeatherEndpoint.swift
//  The Weather
//
//  Created by Alexander Bokhulenkov on 13.05.2025.
//

import Foundation

public enum WeatherEndpoint {
    case current (location: String)
    case days (Int, lat: Double, lon: Double)
    
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
        case .days(let days, let lat, let lon):
            return [
                URLQueryItem(name: "key", value: key),
                URLQueryItem(name: "q", value: "\(lat),\(lon)"),
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
