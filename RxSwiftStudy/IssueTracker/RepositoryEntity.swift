//
//  RepositoryEntity.swift
//  RxSwiftStudy
//
//  Created by jaekyung you on 2020/12/12.
//

import Mapper

struct Repository : Mappable, Decodable {
    let identifier: Int
    let language: String // ex. swift, java, ruby..
    let name: String
    let fullName: String
    
    init(map: Mapper) throws {
        try identifier = map.from("id")
        try language = map.from("language")
        try name = map.from("name")
        try fullName = map.from("full_name")
    }
}
 
