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

    let provider : MoyaProvider<Github> // request할 provider 정의
    let repositoryName : Observable<String>
    //let userName : Observable<String>
    
    
    // 1. Object Mapping이 불가하면 nil, 가능하면 Repository 반환
    func findRepo(_ owner: String) -> Observable<Repository?> {
        return provider.rx
            .request(.repo(fullName: owner))
            .filterSuccessfulStatusAndRedirectCodes()
            .debug()
            .map(Repository?.self)
            .asObservable()
    }
    
    // 2. Find issue given repository
    func findIssue(_ repository: Repository) -> Observable<[Issue]?> {
        return provider.rx
            .request(.issues(repositoryFullName: repository.fullName))
            .filterSuccessfulStatusAndRedirectCodes() // error 생기면 알려주고, 성공하면 넘어감
            .debug()
            .map([Issue]?.self)
            .asObservable()
    }
    
    // 3. 1과 2의 메소드를 연결하는 연산자, Sequence A -> Sequnce B로 만드는 체인 오퍼레이션
    // ex. Sequence(문자열) -> Sequence(레포지토리) or Sequence(레포지토리) -> Sequence(이슈)
    // flapMap(): 하나의 값을 받고 새로운 값이 들어와도 이전 작업을 계속 진행 및 완료
    // flatMapLatest(): 새로운 값을 받으면 이전의 업무는 취소하고 새롭게 작업 시작
    func trackIssue() -> Observable<[Issue]> {
        return repositoryName // Sequence(문자열)인 Observable<String> 출발하여 맵핑 시작
            .observeOn(MainScheduler.instance) // 모델의 목적이 테이블뷰에 바인되는 UI작업임을 확신
            .flatMapLatest{ name -> Observable<Repository?> in // Sequence(문자열) -> Sequence(레포지토리) ing...
                print("search repo named \(name)")
                return self.findRepo(name)
            }
            .flatMapLatest{ repository -> Observable<[Issue]?> in
                // repo가 nil인지 먼저 체크
                guard let repository = repository else { return Observable.just(nil) }
                print("Found \(repository.fullName)")
                return self.findIssue(repository)
            }
            .replaceNilWith([])
    }
     
    
    // userProfile -> repo
    // Githubg case .userProfile
    func findUser(_ name: String) -> Observable<Repository?> {
        return provider.rx
            .request(.repos(username: name))
            .filterSuccessfulStatusAndRedirectCodes()
            .debug()
            .map(Repository?.self)
            .asObservable()
    }
    
    
    
}
