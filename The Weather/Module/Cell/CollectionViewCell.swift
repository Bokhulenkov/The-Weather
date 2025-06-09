//
//  CollectionViewCell.swift
//  The Weather
//
//  Created by Alexander Bokhulenkov on 21.05.2025.
//

import UIKit

final class CollectionViewCell: UICollectionViewCell {
    
    static let identifier = CollectionViewCell.description()
    
    private let vStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let hour: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .customGrey
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .customGrey
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let temperature: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .customGrey
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
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
    
    func configure(timestamp: Int, imageURL: String, temperature: Double) {
        let nowTimestamp = Date.currentHourTimestamp
        if timestamp == nowTimestamp {
            hour.text = "Now"
        } else {
            hour.text = Date.formattedTime(from: timestamp)
        }
        
        iconImageView.loadImage(from: imageURL)
        self.temperature.text = "\(temperature)°"
    }
    
    private func setUI() {
        contentView.addSubview(vStack)
        [
            hour,
            iconImageView,
            temperature
        ].forEach { vStack.addArrangedSubview($0) }
    }
}

//    MARK: - Extensions Constraints

private extension CollectionViewCell {
    func setConstraints() {
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            vStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            vStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            vStack.widthAnchor.constraint(greaterThanOrEqualToConstant: 40),
            
            iconImageView.widthAnchor.constraint(equalToConstant: 24)
        ])
    }
}
