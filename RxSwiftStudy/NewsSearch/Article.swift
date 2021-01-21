//
//  Article.swift
//  RxSwiftStudy
//
//  Created by jaekyung you on 2021/01/21.
//

import Foundation

struct ArticleList: Decodable {
    let articles: [Article]
}

struct Article: Codable{
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
}
