//
//  ApiManager.swift
//  SendbirdAssign
//
//  Created by ygsong on 2021/02/01.
//

import UIKit

class ApiManager: NSObject {
    static let instance = {
        return ApiManager()
    }()
    
    private override init() { }
    
    private func requestApi(request:URLRequest,
                            completion: @escaping (Data?) -> Void) {
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            guard let data = data else {
                completion(nil)
                return
            }
            completion(data)
        })
        
        task.resume()
    }
    
    public func reqSearchBook(name: String,
                       page:Int,
                       completion: @escaping (SearchResponse?) -> Void) {

        let reqObj = ApiReqObj(path: .search,
                               query: name,
                               page: page)

        self.requestApi(request: reqObj.getRequest()) { (response) in
            if let jsonData = response {
                let decoder = JSONDecoder()
                if let response = try? decoder.decode(SearchResponse.self, from: jsonData) {
                    completion(response)
                } else {
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }
    }
    
    public func reqDetailInfo(isbn13:String,
                       completion: @escaping (Book?) -> Void) {
        let reqObj = ApiReqObj(path: .detail, query: isbn13, page: 0)
        self.requestApi(request: reqObj.getRequest()) { (response) in
            if let jsonData = response {
                let decoder = JSONDecoder()
                if let response = try? decoder.decode(Book.self, from: jsonData) {
                    completion(response)
                } else {
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }
        
    }
}
