//
//  IssueListViewModel.swift
//  RxSwiftStudy
//
//  Created by jaekyung you on 2020/12/12.
//

import Foundation
import RxSwift
import Moya
import Mapper
import Moya_ModelMapper
import RxOptional

/*
 Issue Tracker
 Step1. 컨트롤러와 Moya 설정하기: UI그리기 및 Moya의 Endpoint와 TargetType 정의
 Step2. 네트워크 모델과 매핑 오브젝트: 텍스트에 기반해서 데이터를 넘겨주는 모델. 하지만 오브젝트를 보내기 전에 파싱이 필요(by ModelMapper)
 Step3. 테이블뷰에 Issue 바인딩하기: 모델에서 받은 데이터를 테이블뷰에 연결하기 = Observable.bind(to: tableView.)...
 */


// 네트워킹의 핵심부분!
struct IssueTrackerModel {
    
    // 1. 전달할 Provider 속성과 text를 위한 Observable
    let provider = MoyaProvider<Github>()
    let repositoryName: Observable<String>
    
    // ViewController가 테이블뷰에 바인딩하는 데에 사용할 메소드
    func trackIssue() -> Observable<[Issue]> {
        // 아래에서 만든 findIssue, findRepository 메소드 둘을 연결하려면 flatMap(), flatMapLatest()가 있음
        // flatMap(), flatMapLatest()의 역할은 하나의 sequence에서 다른 sequence를 만드는 것 + 새로운 텍스트가 들어오면 이전의 작업을 취소 = flatMapLatest()
        // 문자열 Sequence -> Repository Sequence
        // Repository Sequence -> Issue Sequence
        // 체인 오퍼레이션 이용
        
        
        return repositoryName
            .observeOn(MainScheduler.instance) // 1. UI에 바인딩할 예정이므로 UI thread에서 작업
            
            
            // Repository의 이름을 Repository Sequence로 바꾸고 제대로 mapping되지 않으면 nil 반환
            .flatMapLatest { name -> Observable<Repository?> in // 문자열 Sequence -> Repository Sequence
                //guard let name = name else { return Observable.just(nil) }
                print("\(name)")
//                return self.findRepository(name)
            }
            
            // 매핑된 repository가 nil인지 확인하고 nil이 아니면 Issue 배열로 반환
            .flatMapLatest{ repository -> Observable<[Issue]?> in // Repository Sequence -> Issue Sequence
                guard let repository = repository else { return Observable.just(nil) }
                print("Repo: \(repository.fullname)")
//                return self.findIssue(repository)
            }
            
            .replaceNilWith([])
        
    }
    
    // Find issue given repository
    internal func findIssue(_ repository: Repository) -> Observable<[Issue]>? {
        return provider.rx
            .request(.issues(repositoryFullName: repository.fullName))
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .asObservable()
            .debug()
            //.mapOptional(to: [Issue].self)
            .map{ try JSONDecoder().decode([Issue].self, from: $0.data)}
            //.filterEmpty()
    }
    
    internal func findRepository(_ name: String) -> Observable<Repository>? {
        return provider.rx
            .request(.repo(fullName: name))
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .asObservable()
            .debug()
            .map{ try JSONDecoder().decode(Repository.self, from: $0.data)}
            
    }
     
}
