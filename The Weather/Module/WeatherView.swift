//
//  weatherView.swift
//  The Weather
//
//  Created by Alexander Bokhulenkov on 14.05.2025.
//

import UIKit

final class WeatherView: UIView {
    
    //    MARK: - Properties
    
    private let currentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let cityLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let tempLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let conditionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.isPagingEnabled = true
        collection.layer.cornerRadius = 20
        collection.backgroundColor = .customBlue
        collection.showsHorizontalScrollIndicator = false
        
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.layer.cornerRadius = 20
        tableView.layer.shadowColor = UIColor.black.cgColor
        tableView.layer.shadowOffset = CGSize(width: 1, height: 1)
        tableView.layer.shadowOpacity = 0.5
        tableView.clipsToBounds = false
        tableView.backgroundColor = .customBlue
        tableView.isScrollEnabled = false
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var tableViewHeightConstraint: NSLayoutConstraint!
    
    //    MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //    MARK: - Methods
    
    func showWeather(from weather: Weather?) {
        cityLabel.text = weather?.city
        tempLabel.text = "\(weather!.tempC)°C"
        iconImageView.loadImage(from: weather?.weatherImage ?? "")
        conditionLabel.text = weather?.condition
        
        tableView.reloadData()
        collectionView.reloadData()
        
        DispatchQueue.main.async {
            self.updateTableViewHeight()
        }
    }
    
    func setDelegate(_ vc: ViewController) {
        tableView.delegate = vc
        tableView.dataSource = vc
        collectionView.delegate = vc
        collectionView.dataSource = vc
    }
    
    private func setUI() {
        backgroundColor = .customGreen
        
        addSubview(currentView)
        [
            cityLabel,
            tempLabel,
            iconImageView,
            conditionLabel
        ].forEach { currentView.addSubview($0) }
        [
            collectionView,
            tableView
        ].forEach { addSubview($0) }
        
        tableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: WeatherTableViewCell.identifier)
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.identifier)
    }
    
    private func updateTableViewHeight() {
        tableViewHeightConstraint.constant = tableView.contentSize.height
        tableView.layoutIfNeeded()
    }
}

//    MARK: - Extensions Constraints

private extension WeatherView {
    func setConstraints() {
        NSLayoutConstraint.activate([
            currentView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 15),
            currentView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.6),
            currentView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.15),
            currentView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            cityLabel.topAnchor.constraint(equalTo: currentView.topAnchor, constant: 5),
            cityLabel.centerXAnchor.constraint(equalTo: currentView.centerXAnchor),
            
            iconImageView.topAnchor.constraint(equalTo: cityLabel.bottomAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 50),
            iconImageView.heightAnchor.constraint(equalToConstant: 50),
            iconImageView.centerXAnchor.constraint(equalTo: currentView.centerXAnchor, constant: -50),
            
            tempLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 5),
            tempLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 5),
            
            conditionLabel.topAnchor.constraint(equalTo: tempLabel.bottomAnchor, constant: 5),
            conditionLabel.centerXAnchor.constraint(equalTo: currentView.centerXAnchor),
            
            collectionView.topAnchor.constraint(equalTo: currentView.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            collectionView.heightAnchor.constraint(equalToConstant: 100),
            
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            tableView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 20)
        ])
        
        tableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 1)
        tableViewHeightConstraint.isActive = true
    }
}
