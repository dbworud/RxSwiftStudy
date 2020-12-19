//
//  MultipleStream.swift
//  RxSwiftStudy
//
//  Created by jaekyung you on 2020/12/19.
//

/*
 여러 이벤트의 묶음을 처리하는 코드
 1. UIKit
 2. RxSwift
 3. Combine
*/

import UIKit
import RxSwift
import RxCocoa

import Combine

class MultiStreamViewController: UIViewController {
    
    @IBOutlet weak var optionOne: UISwitch!
    @IBOutlet weak var optionTwo: UISwitch!
    @IBOutlet weak var submit: UIButton!
    
    @Published var optionOneValue: Bool = false
    @Published var optionTwoValue: Bool = false
    var cancellable: Cancellable?
    
    // RxSwift
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* UIKit
        optionOne.tag = 1
        optionOne.addTarget(self, action: #selector(onChanged(_:)), for: .valueChanged)
        
        optionOne.tag = 2
        optionOne.addTarget(self, action: #selector(onChanged(_:)), for: .valueChanged)
         */
        
        /* RxSwift
        Observable.combineLatest(optionOne.rx.value, optionTwo.rx.value) { $0 && $1 }
            .bind(to: submit.rx.isEnabled)
//            .subscribe(onNext: { self.submit.isEnabled = $0 })
            .disposed(by: disposeBag)
         */
        
        // Combine
        optionOne.tag = 1
        optionOne.addTarget(self, action: #selector(onChanged(_:)), for: .valueChanged)
        
        optionOne.tag = 2
        optionOne.addTarget(self, action: #selector(onChanged(_:)), for: .valueChanged)
        
        cancellable = Publishers.CombineLatest($optionOneValue, $optionTwoValue)
            .map{ $0 && $1}
//            .sink{ self.submit.isEnabled = $0 }
            .assign(to: \.isEnabled, on: submit)

    }
    
    @objc func onChanged(_ sw: UISwitch) {
        if sw.tag == 1 { optionOneValue = optionOne.isOn }
        if sw.tag == 2 { optionTwoValue = optionTwo.isOn }
    }
    
    
}
