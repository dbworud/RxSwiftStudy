//
//  ArticleViewModel.swift
//  RxSwiftStudy
//
//  Created by jaekyung you on 2021/01/21.
//

import Foundation
import RxSwift
import RxRelay

final class ArticleViewModel {
    
    let title = "News"
    
    private let articleService: ArticleServiceProtocol // 재사용성, test용이, 의존성 주입
    
    init(articleService: ArticleServiceProtocol) {
        self.articleService = articleService
    }
    
    func fetchArticles() -> Observable<[CellViewModel]> {
        articleService.fetchNews().map{ $0.map { CellViewModel(article: $0) }}
        // [Article] 배열에서 하나씩 뽑아오기
    }
    
}
