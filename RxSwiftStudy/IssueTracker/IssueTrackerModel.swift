//
//  IssueListViewModel.swift
//  RxSwiftStudy
//
//  Created by jaekyung you on 2020/12/12.
//

/*
 Issue Tracker
 Step1. 컨트롤러와 Moya 설정하기: UI그리기 및 Moya의 Endpoint와 TargetType 정의
 Step2. 네트워크 모델과 매핑 오브젝트: 텍스트에 기반해서 데이터를 넘겨주는 모델. 하지만 오브젝트를 보내기 전에 파싱이 필요(by ModelMapper)
 Step3. 테이블뷰에 Issue 바인딩하기: 모델에서 받은 데이터를 테이블뷰에 연결하기 = Observable.bind(to: tableView.)...
 */

import Foundation
