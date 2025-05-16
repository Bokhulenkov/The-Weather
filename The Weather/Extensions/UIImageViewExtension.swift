//
//  UIImageViewExtension.swift
//  The Weather
//
//  Created by Alexander Bokhulenkov on 14.05.2025.
//

import UIKit

extension UIImageView {
    private static let imageCache = NSCache<NSString, UIImage>()
    private static var activeTasks = [NSString: URLSessionTask]()
    
    func loadImage(from urlString: String, placeholder: UIImage? = nil) {
        self.image = placeholder
        
        if let cacheImage = Self.imageCache.object(forKey: urlString as NSString) {
            self.image = cacheImage
            return
        }
        
        Self.activeTasks[urlString as NSString]?.cancel()
        
        guard let url = URL(string: urlString) else {
            print("Invalid url \(urlString)")
            return
        }
        
        let task =  URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            if error != nil {
                print(error?.localizedDescription ?? "unknown error")
                return
            }
            
            guard let data = data else { return }
            guard let image = UIImage(data: data) else { return }
            
            Self.imageCache.setObject(image, forKey: urlString as NSString)
            Self.activeTasks[urlString as NSString] = nil
            
            DispatchQueue.main.async {
                self?.image = image
            }
        }
        Self.activeTasks[urlString as NSString] = task
        task.resume()
    }
}
