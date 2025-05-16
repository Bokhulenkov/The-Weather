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
    private var weather: Weather?
    private var detailWeather: [DetailWeather] = []
    private let weatherView = WeatherView()
    private let countDay = 3
    
    //    MARK: - LifeCicle
    
    override func loadView() {
        view = weatherView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherView.setDelegate(self)
        
        //        network.fetchData(type: WeatherDTO.self, endPoint: .current(location: "LAT")) { result in
        //            switch result {
        //            case .success(let dto):
        //                print(dto.location)
        //                print(dto.current)
        //                self.weather = Weather(from: dto)
        //
        //                DispatchQueue.main.async {
        //                    self.weatherView.showWeather(from: self.weather)
        //                }
        //
        //            case .failure(let error):
        //                print(error.localizedDescription)
        //                print(error.description)
        //            }
        //        }
        
        network.fetchData(type: WeatherDTO.self, endPoint: .days(countDay, location: "LAT")) { result in
            switch result {
            case .success(let dto):
                self.detailWeather = dto.toDetailWeather()
                self.weather = Weather(from: dto)
                
                DispatchQueue.main.async {
                    self.weatherView.showWeather(from: self.weather)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                print(error.description)
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
