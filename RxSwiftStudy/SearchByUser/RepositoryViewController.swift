//
//  RepositoryViewController.swift
//  RxSwiftStudy
//
//  Created by jaekyung you on 2020/12/13.
//

import UIKit
import RxCocoa
import RxSwift
import RxAlamofire
import NSObject_Rx
import ObjectMapper

class RepositoryViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!

    var repositoryNetworkModel: RepositoryNetworkModel!
    
    var searchBarText: Observable<String> {
        return searchBar.rx.text
            .filter{ $0 != nil } // 아예 입력 안한 것 제외
            .map { $0! } // 강제 언래핑
            .filter{ $0.count > 0 } // white space 제외 ? (!$0.isEmpty)
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
     }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpRx()
    }
    
    func setUpRx() {
        repositoryNetworkModel = RepositoryNetworkModel(withNameObservable: searchBarText)
        
        repositoryNetworkModel
            .rx_repository
            .drive(tableView.rx.items) { (tableView, i, repository) in
                let cell = tableView.dequeueReusableCell(withIdentifier: "repositoryCell", for: NSIndexPath(row: i, section: 0) as IndexPath)
                
                cell.textLabel?.text = repository.name
                return cell
            }
            .disposed(by: rx.disposeBag)
        
        
        // DriverNext: Driver를 위한 subscribeNext
        // Alert
        repositoryNetworkModel
            .rx_repository
            .drive(onNext: { repo in
                if repo.count == 0 {
                    let alert = UIAlertController(title: ":(", message: "No repo for this user", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    
                    if self.navigationController?.visibleViewController?.isMember(of: UIAlertController.self) != true {
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            })
        
        
    }
}



