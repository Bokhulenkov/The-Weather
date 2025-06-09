//
//  NetworkError.swift
//  The Weather
//
//  Created by Alexander Bokhulenkov on 13.05.2025.
//

import Foundation

enum HTTPError: Error, LocalizedError {
    case badURL
    case badCreateTask
    case badDataTask
    case noData
    case badDecoder
    case clientError
    case serverError
    
    var description: String {
        switch self {
        case .badURL:
            return "Не валидный url адрес."
        case .badCreateTask:
            return "Не возможно создать Task, пришла ошибка"
        case .badDataTask:
            return "Запрос завершился с ошибкой."
        case .noData:
            return "Нет данных"
        case .badDecoder:
            return "Невозможно декодировать данные"
        case .clientError:
            return "Ошибка на стороне клиента"
        case .serverError:
            return "Ошибка на стороне сервера"
        }
    }
}
