//
//  ViewController.swift
//  The Weather
//
//  Created by Alexander Bokhulenkov on 13.05.2025.
//

import UIKit
import CoreLocation

final class ViewController: UIViewController {
    
    //    MARK: - Properties
    
    private let network = NetworkService()
    private let locationManager = CLLocationManager()
    private let weatherView = WeatherView()
    private let countDay = 3
    private var weather: Weather?
    private var detailWeather: [DetailWeather] = [] {
        didSet {
            hourlyWeather = detailWeather.flatMap { $0.hours }
        }
    }
    private var hourlyWeather: [HourlyWeather] = []
    
    //    MARK: - LifeCicle
    
    override func loadView() {
        view = weatherView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegate()
        setLocation()
    }
    
    //    MARK: - Methods
    
    private func setDelegate() {
        weatherView.setDelegate(self)
        locationManager.delegate = self
    }
    
    private func setLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    private func fetchWeatherLocation(lat: Double, lon: Double) {
        network.fetchData(type: WeatherDTO.self, endPoint: .days(countDay, lat: lat, lon: lon)) { result in
            switch result {
            case .success(let dto):
                self.detailWeather = dto.toDetailWeather()
                self.weather = Weather(from: dto)
                
                DispatchQueue.main.async {
                    self.weatherView.showWeather(from: self.weather)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func fetchWeather(city: String) {
        network.fetchData(type: WeatherDTO.self, endPoint: .current(location: city)) { result in
            switch result {
            case .success(let dto):
                self.weather = Weather(from: dto)
                
                DispatchQueue.main.async {
                    self.weatherView.showWeather(from: self.weather)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

//    MARK: - Extensions UITableViewDelegate, UITableViewDataSource

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailWeather.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier, for: indexPath) as? WeatherTableViewCell else {
            print("Error created WeatherTableViewCell")
            return UITableViewCell()
        }
        
        var backgroundConfig = cell.backgroundConfiguration
        backgroundConfig?.backgroundColor = .customBlue
        backgroundConfig?.cornerRadius = 20
        cell.backgroundConfiguration = backgroundConfig
        cell.selectionStyle = .none
        
        let weather = detailWeather[indexPath.row]
        
        cell.configure(
            timestamp: weather.day,
            imageURL: weather.weatherImage,
            minTemp: weather.minTemp,
            maxTemp: weather.maxTemp
        )
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        20
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        
        let imageView: UIImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(systemName: "calendar")
            imageView.tintColor = .systemBlue
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()
        
        let titleLabel: UILabel = {
            let label = UILabel()
            label.text = "\(countDay)-Day Forecast"
            label.font = UIFont.systemFont(ofSize: 12)
            label.textColor = .systemBlue
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        [
            imageView,
            titleLabel
        ].forEach {headerView.addSubview($0)}
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            imageView.widthAnchor.constraint(equalToConstant: 12),
            imageView.heightAnchor.constraint(equalToConstant: 12),
            
            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16)
        ])
        
        return headerView
    }
}

//    MARK: - Extension CLLocationManagerDelegate

extension ViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            print("When user did not yet determined")
        case .restricted:
            print("Restricted by parental control")
        case .denied:
            print("When user select option Dont't Allow")
        case .authorizedWhenInUse:
            print("When user select option Allow While Using App or Allow Once")
        case .authorizedAlways:
            print("When user select option Allow Always")
        default:
            print("default")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            print("Error getting location")
            return
        }
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        fetchWeatherLocation(lat: lat, lon: lon)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        locationManager.stopUpdatingLocation()
        if let error = error as? CLError {
            switch error.code {
            case .locationUnknown, .denied, .network:
                fetchWeather(city: "Moscow")
                print("Location request failed with error: \(error.localizedDescription)")
            case .headingFailure:
                print("Heading request failed with error: \(error.localizedDescription)")
            case .rangingUnavailable, .rangingFailure:
                print("Ranging request failed with error: \(error.localizedDescription)")
            case .regionMonitoringDenied, .regionMonitoringFailure, .regionMonitoringSetupDelayed, .regionMonitoringResponseDelayed:
                print("Region monitoring request failed with error: \(error.localizedDescription)")
            default:
                print("Unknown location manager error: \(error.localizedDescription)")
            }
        } else {
            print("Unknown error occurred while handling location manager error: \(error.localizedDescription)")
        }
    }
}

//    MARK: - Extensions UICollectionView

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        hourlyWeather.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as? CollectionViewCell else {
            print("Collection cell creating error")
            return UICollectionViewCell()
        }
        
        
        cell.configure()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 100)
    }
}


/*
текущая, почасовая (показывать оставшиеся часы из текущего дня и все часы следующего),
 
 прогноз погоды на 7 дней - Обработать показ загрузки и ошибку,
 
 если что-то пошло не так, с кнопкой повторного запроса
 
 По дизайну никаких ограничений нет, можно ориентироваться на погодное приложение Apple
 
Геолокация и запросы - Запрашивать разрешение на использование геопозиции пользователя в самом начале (при отказе – использовать Москву)
 */
