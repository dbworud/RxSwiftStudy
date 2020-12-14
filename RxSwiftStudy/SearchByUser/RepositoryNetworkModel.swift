//
//  RepositoryNetworkModel.swift
//  RxSwiftStudy
//
//  Created by jaekyung you on 2020/12/13.
//

/*
 Step1. UI와 컨트롤러
 Step2. 네트워크 모델과 오브젝트 맵핑
 Step3. 멀티스레딩 최적화
 */

import ObjectMapper
import RxAlamofire
import RxSwift
import RxCocoa

// 모델을 특정한 Observable<String> -> Observable<[Repository]> 반환하는 메소드
// 이 메소드를 ViewController의 뷰에 붙임


struct RepositoryNetworkModel {
    
    fileprivate var repositoryName : Observable<String>
    lazy var rx_repository : Driver<[Repo]> = self.fetchRepositiry() // lazy var 만들어서 메소드에게 레포지터리 검색, 유일한 단점은 init 명시
    
    init(withNameObservable nameObservable : Observable<String>) {
        self.repositoryName = nameObservable
    }
    
    
    // Observable이 아닌 Driver: "나는 메인스레드에 올라갈테니까 걱정하지말고 바인딩해"라고 말해주는 변수, 이렇게하면 바인딩할 때 오류가 발생하지 않음
    // ViewController에 바인딩할 때 bindTo() -> drive()
    fileprivate func fetchRepositiry() -> Driver<[Repo]> {
        return repositoryName
            .flatMapLatest{ text in
                return RxAlamofire
                    .json(.get, "https://api.github.com/users/\(text)/repos")
                    .debug()
                    .catchError { error in
                        return Observable.never()
                    }
            }
            .map { (json) -> [Repo] in
                if let repos = Mapper<Repo>().mapArray(JSONObject: json) {
                    return repos
                } else {
                    return []
                }
            }
            .asDriver(onErrorJustReturn: []) // Main thread에 있음을 확신
    }
    
    
}
