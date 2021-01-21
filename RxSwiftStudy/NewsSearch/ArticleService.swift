//
//  ArticleService.swift
//  RxSwiftStudy
//
//  Created by jaekyung you on 2021/01/21.
//

import Foundation
import Alamofire
import RxSwift

// 재사용성, test용이
protocol ArticleServiceProtocol {
    func fetchNews() -> Observable<[Article]>
}


class ArticleService: ArticleServiceProtocol{
    
    func fetchNews() -> Observable<[Article]> {
        return Observable.create { (observer) -> Disposable in
            
            self.fetchNews { (error, articles) in
                if let error = error {
                    observer.onError(error)
                }

                if let articles = articles {
                    observer.onNext(articles)
                }

                observer.onCompleted()
            }
    
            return Disposables.create()
        }
    }
    
    private func fetchNews(completion: @escaping((Error?, [Article]?) -> Void)) {
     let urlString = URL(string: "http://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=9282a704611d41ebada03bfe92bc89a3")
     
        guard let url = urlString else { return }
        
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .responseDecodable(of: ArticleList.self) { response in
                if let error = response.error {
                    return completion(error, nil)
                }
                
                if let articles = response.value?.articles {
                    return completion(nil, articles)
                }
            }
    }
}
