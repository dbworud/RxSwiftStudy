//
//  CellViewModel.swift
//  RxSwiftStudy
//
//  Created by jaekyung you on 2021/01/21.
//

import Foundation

struct CellViewModel {
    private let article: Article
    
    var imageUrl: String? {
        return article.urlToImage
    }
    
    var title: String? {
        return article.title
    }
    
    var description: String? {
        return article.description
    }
    
    init(article: Article) {
        self.article = article
    }
    

}
