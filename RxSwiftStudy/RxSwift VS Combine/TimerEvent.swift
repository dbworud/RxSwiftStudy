//
//  TimerEvent.swift
//  RxSwiftStudy
//
//  Created by jaekyung you on 2020/12/19.
//

/*
 
 
 */

import UIKit
import RxSwift
import RxCocoa

import Combine

class TimerEventViewController: UIViewController {
    var timer : Timer?
    
    // RxSwift
    var disposeBag = DisposeBag()
    
    // Combine
    var cancellable : Cancellable?
    
    @IBOutlet weak var timeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onStart(_ sender: Any) {
        /*
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            let currentTimeInMilli = Date().timeIntervalSince1970 * 1000
            self.timeLabel.text = "\(currentTimeInMilli)"
        }
         */
        
        /* RxSwift
        disposeBag = DisposeBag()
        Observable<Int>.interval(.milliseconds(100), scheduler: ConcurrentMainScheduler.instance)
            .map{ _ in Date().timeIntervalSince1970 * 1000}
            .map{ "\($0)"}
            .subscribe(onNext: { self.timeLabel.text = $0})
            .disposed(by: disposeBag)
         */
        
        // Combine
        cancellable?.cancel()
        cancellable = Timer.publish(every: 0.1, on: RunLoop.main, in: .default)
            .autoconnect()
            .map{ _ in Date().timeIntervalSince1970 * 1000}
            .map {"\($0)"}
            .sink{ self.timeLabel.text = $0 }
        
    }
    
    @IBAction func onStop(_ sender: Any) {
//        timer?.invalidate()
//        disposeBag = DisposeBag()
        cancellable?.cancel()
    }
}
