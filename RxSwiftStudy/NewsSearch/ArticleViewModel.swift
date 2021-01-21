//
//  ArticleViewModel.swift
//  RxSwiftStudy
//
//  Created by jaekyung you on 2021/01/21.
//

import Foundation
import RxSwift

final class ArticleViewModel {
    
    let title = "News"
    
    private let articleService: ArticleServiceProtocol // 재사용성, test용이, 의존성 주입
    
    init(articleService: ArticleServiceProtocol) {
        self.articleService = articleService
    }
    
    func fetchArticles() -> Observable<[Article]> {
        return articleService.fetchNews()
    }
}
