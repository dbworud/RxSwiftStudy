//
//  MemoryManage.swift
//  RxSwiftStudy
//
//  Created by jaekyung you on 2020/12/19.
//

/*
 비동기 작업에서 메모리 관리하는 법
 1. deinit (기존)
 2. DisposeBag (RxSwift)
 3. Cancellable (Combine)
 */

import UIKit
import RxSwift
import RxCocoa

import Combine


class PopupViewController : UIViewController {
    var timer: Timer?
    
    // RxSwift
    var disposeBag = DisposeBag()
    
    // Combine
    var cancellable: Cancellable?
    var anyCancellable : AnyCancellable?
    
    @IBOutlet weak var timeLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true){ [weak self] _ in
            let currentTimeInMill = Date().timeIntervalSince1970 * 1000
            print(currentTimeInMill)
            self?.timeLabel.text = "\(currentTimeInMill)"
        }
        */
        
        /*
        Observable<Int>.interval(.milliseconds(100), scheduler: ConcurrentMainScheduler.instance)
            .map { _ in Date().timeIntervalSince1970 * 1000}
            .map {"\($0)"}
            .debug()
            .bind(to: timeLabel.rx.text)
            .disposed(by: disposeBag)
        */
        
        let c = Timer.publish(every: 0.1, on: .main, in: .default)
            .autoconnect()
            .map { _ in Date().timeIntervalSince1970 * 1000}
            .map{"\($0)"}
            .print()
//            .assign(to: \.text, on: timeLabel)
            .sink(receiveValue: { [weak self] in
                self?.timeLabel.text = $0
            })
        
        anyCancellable = AnyCancellable(c)
    }
    
    /*
    deinit {
        timer?.invalidate() // timer stop
    }
    */
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

class HomeViewController: UIViewController {

    @IBAction func showPopup(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(identifier: "PopupViewController") {
            present(vc, animated: true, completion: nil)
        }
    }
}
