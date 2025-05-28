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
        stack.distribution = .equalCentering
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let hour: UILabel = {
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
    
    func configure() {
        hour.text = "18"
        iconImageView.image = UIImage(resource: .placeholder)
        temperature.text = "24°"
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
            vStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            vStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            vStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            hour.topAnchor.constraint(equalTo: vStack.topAnchor, constant: 5),
            hour.centerXAnchor.constraint(equalTo: vStack.centerXAnchor),
            
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
}
