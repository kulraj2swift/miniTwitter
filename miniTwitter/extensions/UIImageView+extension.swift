//
//  UIImageView+extension.swift
//  miniTwitter
//
//  Created by kulraj singh on 20/01/23.
//

import Foundation
import UIKit

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        if let imageData = UserDefaults.standard.data(forKey: url.absoluteString),
           let cachedImage = UIImage(data: imageData) {
            image = cachedImage
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                UserDefaults.standard.set(data, forKey: url.absoluteString)
                self?.image = image
            }
        }.resume()
    }
    
    func downloaded(from link: String?, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let link = link else { return }
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
