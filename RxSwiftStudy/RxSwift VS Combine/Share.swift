//
//  Share.swift
//  RxSwiftStudy
//
//  Created by jaekyung you on 2020/12/18.
//

/*
 하나의 stream을 여러번 구독할 때에는 share가 필요
 구독될 때 데이터의 흐름(stream)이 시작되는데 그 과정에서 operation이 중복처리될 수 있음
 share는 처리를 끝낸 데이터를 중복처리하지 않고 여러 구독자가 공유할 수 있도록
 */

import Foundation
import RxCocoa
import RxSwift

import Combine
import CancelBag

class ShareViewController: UIViewController {
    
    // RxSwift
    let stream = PublishSubject<Double>()
    var disposeBag = DisposeBag()
    
    // Combine
    let combineStream = PassthroughSubject<Double, Never>()
    var cancellable : [Cancellable] = []
     
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        // RxSwift
        let heavyCalc = stream
            .do(onNext: { _ in print("Heavy Calc") })
            .map{ $0 * .pi / 180 }
            .share()
        
        heavyCalc
            .map{ "\($0)" }
            .subscribe(onNext: { rad in
                print("Subscribe #1: \(rad)")
            })
            .disposed(by: disposeBag)
        
        heavyCalc
            .map{ Int($0) } // Double -> Int
            .map{ "\($0)" }
            .subscribe(onNext: { rad in
                print("Subscribe #2: \(rad)")
            })
            .disposed(by: disposeBag)
        
        
        heavyCalc
            .subscribe(onNext: { _ in
                print("---------------")
            })
            .disposed(by: disposeBag)
        */
        
        // RxSwift to Combine
        let heavyCalc = combineStream
            .handleEvents(receiveOutput: { _ in print("Heavy Calc") })
            .map{ $0 * .pi / 180 }
            .share()
        
       let c1 = heavyCalc
            .map{ "\($0)" }
            .sink(receiveValue: { rad in
                print("Subscribe #1: \(rad)")
            })
        cancellable.append(c1)
        
        let c2 = heavyCalc
            .map{ Int($0) } // Double -> Int
            .map{ "\($0)" }
            .sink(receiveValue: { rad in
                print("Subscribe #2: \(rad)")
            })
        cancellable.append(c2)
        
        
        let c3 = heavyCalc
            .sink(receiveValue: { _ in
                print("---------------")
            })
        cancellable.append(c3)
        
    }

    @IBAction func onFire(_ sender: Any) {
        let randomDegree = (0...360).randomElement() ?? 0
        combineStream.send(Double(randomDegree))
    }
    
}
