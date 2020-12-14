//
//  GithubEndpoint.swift
//  RxSwiftStudy
//
//  Created by jaekyung you on 2020/12/13.
//

import Foundation
import Moya

/*
Moya: 보통 우리가 직접 관리해야할 모든 네트워킹 관련 요소들 위에 있는 추상적인 layer. 바로 API와 연결 가능
Moya를 설정하려면
 1. Provider : 스터빙(stubbing), 엔드포인트 클로저 등으로 이루어며, MoyaProvider통해 request 수행
 2. Endpoint 설정 : 가능한 엔드포인트 타겟들을 enum
 3. Sample Data : Moya는 테스트 의존적이기 때문에 테스트 구문을 일등시민으로 간주
 
 !! 모든 Request마다 서버의 샘플 응답을 지정 !!
 
 - Github API를 사용해서 특정 Repository의 Issue fetch
 - Repository 오브젝트가 존재하는지 확인하고, Issue를 가져오는 request 날리기
 - JSON -> Object Mapping
 - 에러, 중복 리퀘스트, API 스패밍 등을 관리
 */


// Endpoint: 가능한 타겟에 대한 enum
enum Github {
    case userProfile(username: String)
    case repos(username: String)
    case repo(fullName: String)
    case issues(repositoryFullName: String)
}

private extension String {
    var URLEscapedString : String {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)!
    }
}

// enum에 따른 TargetType : url, method, task(request/upload/download), parameter, parameter encoding을 가지고 있는 프로토콜
// 여기서는 7가지 필요 -> baseUrl, path, param, paramEncodigg, method, sampleData, task

extension Github : TargetType {
    
    var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }
    
    // URL = baseURL + path 즉, path는 query부분
    var path: String {
        switch self {
        case .userProfile(let name):
            return "/users/\(name.URLEscapedString)"
        case .repos(let name):
            return "/users/\(name.URLEscapedString)/repos"
        
        // https://api.github.com/repos/{owner}/{repo}/issues로 api 변경된 것 같음
        case .repo(let owner):
            return "/repos/\(owner)"
        case .issues(let repo):
            return "/repos/\(repo)/issues"
        }
    }
    
    // HTTP method used in the request.
    var method: Moya.Method {
        return .get
    }
    
    // Provides stub data for use in testing.
    var sampleData: Data {
        switch self {
        case .userProfile(let name):
            return "{\"login\": \"\(name)\", \"id\": 100}".data(using: .utf8)!
        case .repo(_):
            return "{\"id\": \"1\", \"language\": \"Swift\", \"url\": \"https://api.github.com/repos/mjacko/Router\", \"name\": \"Router\"}".data(using: .utf8)!
        case .repos(_):
            return "}".data(using: .utf8)!
        case .issues(_):
            return "{\"id\": 132942471, \"number\": 405, \"title\": \"Updates example with fix to String extension by changing to Optional\", \"body\": \"Fix it pls.\"}".data(using: .utf8)!
        }
    }
    
    // The type of HTTP task to be performed.
    var task: Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var parameterEncoding: ParameterEncoding {
        return JSONEncoding.default
    }
}
