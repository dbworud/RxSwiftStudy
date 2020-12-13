//
//  IssueListViewController.swift
//  RxSwiftStudy
//
//  Created by jaekyung you on 2020/12/12.
//

import UIKit
import Moya_ModelMapper
import Moya
import RxCocoa
import RxSwift
import NSObject_Rx

class IssueListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!

    var latestRepoName : Observable<String> {
        return searchBar
            .rx.text
            .orEmpty
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpRx()
    }
    
    func setUpRx() {
        
        // Request를 수행할 Moya의 Provider
        var provider = MoyaProvider<Github>()
        
        // 유저가 셀을 클릭했을 때 테이블뷰에게 알려줌
        // cell을 클릭하면(= itemSelected) RxSwift로 hide keyboard
        tableView
            .rx.itemSelected // 셀을 탭하면 신호를 보냄
            .subscribe(onNext: { indexPath in
                if self.searchBar.isFirstResponder == true { // 서치바가 firstResponser = keyboard가 나타나고 있음
                    self.view.endEditing(true)
                }
            })
            .disposed(by: rx.disposeBag)
    }
    
    func url(_ route: TargetType) -> String {
        // TargetType의 baseURL에 path를 붙이고 URL -> String으로 변환
        return route.baseURL.appendingPathComponent(route.path).absoluteString
        // abosoluteString for url
    }
    
}
