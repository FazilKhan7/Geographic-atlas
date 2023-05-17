//
//  CachingImage.swift
//  StrongTeamTestAssignmentChecker
//
//  Created by Bakhtiyarov Fozilkhon on 17.05.2023.
//

import Foundation
import UIKit

class CachingImage {
    
    let imageCache = NSCache<NSString, UIImage>()
    
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        // Проверяем, закэшировано ли уже изображение
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            // Изображение найдено в кеше, возвращаем его
            completion(cachedImage)
            return
        }
        
        // Изображение не кэшировано, скачайте его
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print("Failed to download image: \(error)")
                completion(nil)
                return
            }
            
            if let data = data, let image = UIImage(data: data) {
                // Изображение успешно загружено, кэшируем его
                self.imageCache.setObject(image, forKey: url.absoluteString as NSString)
                completion(image)
            } else {
                // Не удалось преобразовать данные в изображение
                completion(nil)
            }
        }
        task.resume()
    }
}
