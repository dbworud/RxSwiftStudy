//
//  ViewController.swift
//  RxSwiftStudy
//
//  Created by jaekyung you on 2020/12/12.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let allCities = ["London", "New York", "Los Angeles", "Osolo", "Cincinnati", "Seoul", "Busan", "Washington", "San Francisco"]
    var shownCities = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }

    
    func setUp() {
        // 1. 테이블뷰에 뿌릴 데이터를 바인딩
        tableView.dataSource = self
        
        // 2. 서치바가 작동할 Rx 구현 및 구독
        searchBar
            .rx.text // RxCocoa로 UI와 바인딩
            .orEmpty // make it non-optionl
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance) // UI와 바인딩하기 때문에 Main thread + 0.5초의 delay
            .distinctUntilChanged() // 이전 값과 다르면 방출
            .filter { !$0.isEmpty } // 비어있지 않은 경우만
            
            // 이제부터 구독 시작
            // [unowned self] : 값이 있음을 확신, dispose될 시에 강한 순환 참조로 인해 참조값이 없어지는 걸 방지
            .subscribe(onNext: { [unowned self] query in
                self.shownCities = self.allCities.filter{ $0.hasPrefix(query) }
                self.tableView.reloadData()
            })
            .disposed(by: rx.disposeBag) // 등록해놓은 Observable을 해제함으로써 메모리 해제
    }

}


// 테이블뷰와 데이터를 바인딩하기 위해 프로토콜인 UITableViewDataSource를 extension으로 사용
extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shownCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityPrototypeCell", for: indexPath)
                cell.textLabel?.text = shownCities[indexPath.row]
        return cell
    }
}
