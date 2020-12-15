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
            .subscribeOn(MainScheduler.instance) // Main thread에 있음을 알려줌
            // Network request가 진행되고 있음을 유저에게 알려주고 싶음
            .do(onNext: { response in
                UIApplication.shared.isNetworkActivityIndicatorVisible = true // deprecated
            })
            // UI thread가 압도당할 수 있기 때문에 request와 mapping전에 백그라운드 스레드로 변경하고 UI thread에 업데이트
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .flatMapLatest{ text in
                return RxAlamofire
                    .json(.get, "https://api.github.com/users/\(text)/repos")
                    .debug()
                    .catchError { error in
                        return Observable.never()
                    }
            }
            // 다시 백그라운드 스레드에서 맵핑
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .map { (json) -> [Repo] in
                if let repos = Mapper<Repo>().mapArray(JSONObject: json) {
                    return repos
                } else {
                    return []
                }
            }
            .observeOn(MainScheduler.instance)
            .do(onNext:{ response in
                UIApplication.shared.isNetworkActivityIndicatorVisible = true // deprecated
            })
            .asDriver(onErrorJustReturn: []) // UI thread로 돌아옴
    }
    
    
}
