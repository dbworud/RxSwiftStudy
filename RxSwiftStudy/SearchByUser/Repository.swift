//
//  Repository.swift
//  RxSwiftStudy
//
//  Created by jaekyung you on 2020/12/13.
//

import ObjectMapper

class Repo: Mappable {
    var identifier: Int!
    var language : Int!
    var url: String!
    var name: String!
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        identifier <- map["identifier"]
        language <- map["language"]
        url <- map["url"]
        name <- map["name"]
    }

    
}
