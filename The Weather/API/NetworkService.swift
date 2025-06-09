//
//  NetworkService.swift
//  The Weather
//
//  Created by Alexander Bokhulenkov on 13.05.2025.
//

import Foundation

final class NetworkService {
    
    let baseURL = "https://api.weatherapi.com"
    let key = "fa8b3df74d4042b9aa7135114252304"
    let sessions = URLSession(configuration: .default)
    let decoder = JSONDecoder()
    
    func fetchData<T: Decodable> (
        type: T.Type,
        endPoint: WeatherEndpoint,
        completion: @escaping (Result<T, HTTPError>) -> Void) {
            guard let safeURL = URL(string: baseURL) else {
                completion(.failure(.badURL))
                debugPrint(HTTPError.self)
                return
            }
            
            let url = endPoint.url(baseURL: safeURL, key: key)
            let request = URLRequest(url: url)
            
            performRequest(request: request, completion: completion)
        }
}

//    MARK: - Extensions NetworkService

extension NetworkService {
    private func performRequest<T: Decodable> (
        request: URLRequest,
        completion: @escaping (Result<T, HTTPError>) -> Void
    ) {
        let dataTask = sessions.dataTask(with: request) { data, response, error in
            
            if let error = error {
                completion(.failure(.badCreateTask))
                debugPrint(error)
                return
            }
            
            if let response = response as? HTTPURLResponse {
//                debugPrint(response)
                switch response.statusCode {
                case 400..<500 :
                    completion(.failure(.clientError))
                    return
                case 500..<600 :
                    completion(.failure(.serverError))
                    return
                default:
                    break
                }
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let decodedData = try self.decoder.decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(.badDecoder))
                debugPrint(error)
                return
            }
        }
        dataTask.resume()
    }
}
