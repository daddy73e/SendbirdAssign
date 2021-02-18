//
//  ImageCacheManager.swift
//  SendbirdAssign
//
//  Created by ygsong on 2021/02/18.
//

import Foundation
class ImageCacheManager:NSObject {
    
    static let instance = { () -> NSCache<AnyObject, AnyObject> in
        let cache = NSCache<AnyObject, AnyObject>()
        cache.totalCostLimit = 50
        return cache
    }()

    private override init() { }

}

