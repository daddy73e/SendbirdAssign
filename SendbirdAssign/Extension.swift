//
//  Extension.swift
//  SendbirdAssign
//
//  Created by ygsong on 2021/02/02.
//

import UIKit

var imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    func loadImage(urlString: String, completion: @escaping () -> Void) {
        if let cacheImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cacheImage
            return
        }
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Couldn't download image: ", error)
                return
            }
            
            guard let data = data else {
                return
            }
            if let image = UIImage(data: data) {
                imageCache.setObject(image, forKey: urlString as AnyObject)
                DispatchQueue.main.async {
                    self.image = image
                    completion()
                }
            }
        }.resume()
        
    }
}


extension UIViewController {
    
    func showAlertOk(title:String?,
                     message:String,
                     completion: (() -> Void)?) {
        let title = title == nil ? "ALERT" : title
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            if let completion = completion {
                completion()
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertYN(title:String?,
                     message:String,
                     completion: ((Bool) -> Void)?) {
        let title = title == nil ? "ALERT" : title
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { _ in
            if let completion = completion {
                completion(true)
            }
        }))
        alert.addAction(UIAlertAction(title: "NO", style: .default, handler: { _ in
            if let completion = completion {
                completion(false)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
