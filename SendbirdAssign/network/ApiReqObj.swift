//
//  ApiReqObj.swift
//  SendbirdAssign
//
//  Created by ygsong on 2021/02/01.
//

import UIKit

struct ApiReqObj {
    private let baseUrl = "https://api.itbook.store/1.0/"
    var path:ApiPath = .none
    var query:String = ""
    var page:Int = 0
    
    public func getRequest() -> URLRequest {
        var reqPath = "\(baseUrl)\(path.rawValue)"
        
        if !query.isEmpty {
            reqPath = "\(reqPath)/\(query)"
        }
        
        if page != 0 {
            reqPath = "\(reqPath)/\(page)"
        }
        
        let components = URLComponents(string: reqPath)!
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        return request
    }
    
    
}
