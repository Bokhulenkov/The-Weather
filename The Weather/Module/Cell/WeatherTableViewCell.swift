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
    
    private let temperatureProgressBar: UIProgressView = {
        let progressBar = UIProgressView()
        progressBar.clipsToBounds = true
        progressBar.layer.cornerRadius = 5
        progressBar.trackTintColor = .systemGray
        
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        return progressBar
    }()
    
    private let separator: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var isGradientRendered = false
    
    //    MARK: - init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !isGradientRendered && temperatureProgressBar.bounds.width > 0 {
            let progressView = GradientView(frame: temperatureProgressBar.bounds)
            temperatureProgressBar.progressImage = progressView.drawUIImage()
            isGradientRendered = true
        }
    }
    
    //    MARK: - Methods

    func configure(timestamp: Int, imageURL: String, minTemp: Double, maxTemp: Double) {
        self.day.text = Date.weekday(from: timestamp)
        self.iconImageView.loadImage(from: imageURL)
        self.maxTemp.text = "\(maxTemp)°"
        self.minTemp.text = "\(minTemp)°"
        
        let maxProgressTemp: Float = 100 / 57
        let progress = (maxProgressTemp * Float(maxTemp)) / 100
        temperatureProgressBar.setProgress(progress, animated: true)
    }
    
    private func setUI() {
        [
            day,
            iconImageView,
            maxTemp,
            minTemp,
            temperatureProgressBar,
            separator
        ].forEach {contentView.addSubview($0)}
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        temperatureProgressBar.progressImage = nil
        isGradientRendered = false
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
            
            temperatureProgressBar.leadingAnchor.constraint(equalTo: minTemp.trailingAnchor, constant: 5),
            temperatureProgressBar.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            temperatureProgressBar.widthAnchor.constraint(equalToConstant: 120),
            temperatureProgressBar.heightAnchor.constraint(equalToConstant: 10),
            
            maxTemp.leadingAnchor.constraint(equalTo: temperatureProgressBar.trailingAnchor, constant: 15),
            maxTemp.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            separator.topAnchor.constraint(equalTo: contentView.topAnchor),
            separator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            separator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            separator.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
}
