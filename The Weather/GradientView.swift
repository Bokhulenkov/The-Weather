//
//  TemperatureProgressBar.swift
//  The Weather
//
//  Created by Alexander Bokhulenkov on 16.05.2025.
//

import UIKit

final class GradientView: UIView {
    
    private let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        gradientLayer.colors = [
            UIColor.blue.cgColor,
            UIColor.green.cgColor,
            UIColor.yellow.cgColor,
            UIColor.orange.cgColor,
            UIColor.red.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        layer.addSublayer(gradientLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if gradientLayer.frame != bounds {
            gradientLayer.frame = bounds
        }
    }
    
    func drawUIImage() -> UIImage {
        let rendered = UIGraphicsImageRenderer(size: self.bounds.size)
        let img = rendered.image { context in
            self.layer.render(in: context.cgContext)
        }
        return img
    }
}
