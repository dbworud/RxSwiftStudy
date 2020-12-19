//
//  DataBinding.swift
//  RxSwiftStudy
//
//  Created by jaekyung you on 2020/12/19.
//

/*
 비동기작업에서 데이터 바인딩하는 법
 1. didSet (기존)
 2. Publish/Behavior Subject (RxSwift)
 3. Passthrough/CurrentValue SUbject (Combine)
 */

import UIKit
import RxCocoa
import RxSwift

import Combine


class DataBindingViewController: UIViewController {
     
    /*
    var count = 0 {
        didSet {
//            self.countLabel.text = "\(count)"
//            self.behavior.onNext(count)
//            self.passthrough.send(count)
            self.currentValue.send(count)
        }
    }
    */
    
    // RxSwift
    let publisher = PublishSubject<Int>()
    let behavior = BehaviorSubject<Int>(value: 0)
    var disposeBag = DisposeBag()
    
    // Combine
    let passthrough = PassthroughSubject<Int, Never>()
    let currentValue = CurrentValueSubject<Int, Never>(0)
    var cancellable : Cancellable?
    
    @Published var count0 = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        behavior
//            .map{ "\($0)" }
//            .bind(to: countLabel.rx.text)
//            .disposed(by: disposeBag)
//        cancellable = currentValue.map{"\($0)"}.assign(to: \.text, on: countLabel)
//        count = 0
         
        cancellable = $count0.map{ "\($0)" }.assign(to: \.text, on: countLabel )
    }
    
    // MARK: - UI
    @IBOutlet weak var countLabel: UILabel!
    
    @IBAction func onMinus(_ sender: Any) {
        count0 -= 1
    }
    @IBAction func onPlus(_ sender: Any) {
        count0 += 1
    }
}
