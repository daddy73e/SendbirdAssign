//
//  ResponseData.swift
//  SendbirdAssign
//
//  Created by ygsong on 2021/02/01.
//

import Foundation

struct Response:Codable {
    var page:String
    var total:String
    var books:[Book]
}
