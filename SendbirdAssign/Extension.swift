//
//  Extension.swift
//  SendbirdAssign
//
//  Created by ygsong on 2021/02/02.
//

import UIKit
import Foundation
import SystemConfiguration

extension UIImageView {
    
    func loadImage(urlString: String, completion: @escaping () -> Void) {
        
        if let cacheImage = ImageCacheManager.instance.object(
            forKey: urlString as AnyObject) as? UIImage {
            self.image = cacheImage
            return
        }
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        self.image = UIImage(named: "logo")
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Couldn't download image: ", error)
                return
            }
            
            guard let data = data else {
                return
            }
            if let image = UIImage(data: data) {
                ImageCacheManager.instance.setObject(image,
                                                     forKey: urlString as AnyObject)
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
    
    
    func connectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in(sin_len: 0,
                                      sin_family: 0,
                                      sin_port: 0,
                                      sin_addr: in_addr(s_addr: 0),
                                      sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        return ret
    }
}
