//
//  Book.swift
//  SendbirdAssign
//
//  Created by ygsong on 2021/01/29.
//

import Foundation

struct Book:Codable {
    var title:String
    var isbn13:String
    var subtitle:String?
    var price:String?
    var image:String?
    var url:String?
    
    var error:String?
    var authors:String?
    var publisher:String?
    var isbn10:String?
    var pages:String?
    var language:String?
    var year:String?
    var rating:String?
    var desc:String?
    var pdf:[String:String]?
}
