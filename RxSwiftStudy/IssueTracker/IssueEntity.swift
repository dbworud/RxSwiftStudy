//
//  IssueEntity.swift
//  RxSwiftStudy
//
//  Created by jaekyung you on 2020/12/12.
//

import Mapper

struct Issue : Mappable, Decodable {
    
    let identifier: Int
    let number: Int
    let title: String
    let body: String
    
    init(map: Mapper) throws {
        try identifier = map.from("id")
        try number = map.from("number")
        try title = map.from("title")
        try body = map.from("body")
    }
}
