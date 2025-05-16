//
//  WeatherTableViewCell.swift
//  The Weather
//
//  Created by Alexander Bokhulenkov on 15.05.2025.
//

import UIKit

final class WeatherTableViewCell: UITableViewCell {
    
    static let identifier = WeatherTableViewCell.description()
    
    private let day: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .customGrey
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .customGrey
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let maxTemp: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .customGrey
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let minTemp: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .customGrey
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //    MARK: - init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //    MARK: - Methods
    
    private func setUI() {
        [
            day,
            iconImageView,
            maxTemp,
            minTemp
        ].forEach {contentView.addSubview($0)}
    }
    
    func configure(timestamp: Int, imageURL: String, minTemp: Double, maxTemp: Double) {
        self.day.text = Date.weekday(from: timestamp)
        self.iconImageView.loadImage(from: imageURL)
        self.maxTemp.text = "\(maxTemp)°"
        self.minTemp.text = "\(minTemp)°"
    }
    
    override func prepareForReuse() {
        iconImageView.image = nil
    }
}

//    MARK: - Extensions Constraints

private extension WeatherTableViewCell {
    func setConstraints() {
        NSLayoutConstraint.activate([
            day.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            day.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            day.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 60),
            iconImageView.heightAnchor.constraint(equalToConstant: 30),
            iconImageView.widthAnchor.constraint(equalToConstant: 30),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            minTemp.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 25),
            minTemp.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            maxTemp.leadingAnchor.constraint(equalTo: minTemp.trailingAnchor, constant: 15),
            maxTemp.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
