//
//  weatherView.swift
//  The Weather
//
//  Created by Alexander Bokhulenkov on 14.05.2025.
//

import UIKit

protocol WeatherViewProtocol: AnyObject {
    func updateLocation()
}

final class WeatherView: UIView {
    
    //    MARK: - Properties
    
    weak var delegate: WeatherViewProtocol?
    
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
    
    private var collectionView: UICollectionView
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.layer.cornerRadius = 20
        tableView.layer.shadowColor = UIColor.black.cgColor
        tableView.layer.shadowOffset = CGSize(width: 1, height: 1)
        tableView.layer.shadowOpacity = 0.5
        tableView.clipsToBounds = false
        tableView.isScrollEnabled = false
        tableView.backgroundColor = .customBlue
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var tableViewHeightConstraint: NSLayoutConstraint!
    
    private let updateLocationButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 1, height: 1)
        button.layer.shadowOpacity = 0.5
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .capsule
        config.baseBackgroundColor = .customBlue
        config.baseForegroundColor = .customGrey
        config.title = "Update Locations"
        button.configuration = config
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //    MARK: - init
    
    override init(frame: CGRect) {
        let layout = WeatherView.makeLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(frame: frame)
        setUI()
        configureCollectionView()
        updateLocationButton.addTarget(self, action: #selector(updateLocationsTapped), for: .touchUpInside)
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
        delegate = vc
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
            tableView,
            updateLocationButton
        ].forEach { addSubview($0) }
        
        tableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: WeatherTableViewCell.identifier)
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.identifier)
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.identifier)
    }
    
    private func updateTableViewHeight() {
        let headerHeight = tableView.delegate?.tableView?(tableView, heightForHeaderInSection: 0) ?? 0
        tableViewHeightConstraint.constant = tableView.contentSize.height - headerHeight
    }
    
    private static func makeLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1/6),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.7)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0)
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(30)
        )
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        section.boundarySupplementaryItems = [sectionHeader]
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    private func configureCollectionView() {
        collectionView.layer.cornerRadius = 20
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .customBlue
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    //    MARK: - Actions
    
    @objc private func updateLocationsTapped(_ sender: UIButton) {
        delegate?.updateLocation()
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
            tableView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 20),
            
            updateLocationButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 10),
            updateLocationButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20)
            
        ])
        
        tableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 1)
        tableViewHeightConstraint.isActive = true
    }
}
