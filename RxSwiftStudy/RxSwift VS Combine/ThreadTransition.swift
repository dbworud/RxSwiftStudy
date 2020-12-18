//
//  ThreadTransition.swift
//  RxSwiftStudy
//
//  Created by jaekyung you on 2020/12/18.
//

import Foundation
import UIKit
import Then
import RxCocoa
import RxSwift

import Combine
import CancelBag

/*
 RxSwift에서..
 observeOn은 DownStream에 영향, subscribeOn은 UpStream에 영향
 Scheduler를 만들어서 사용 ex. DispatchQueue.main/global ...
 
 Combine에서..
 receive(on:) = observeOn(), subscribe(on:) = subscribeOn()
 OperationQueue를 직접 사용 가능
 */

let IMAGE_URL = "https://picsum.photos/400/400/?random"

func currentThreadName() -> String {
    return OperationQueue.current?.name ?? "Unknown Thread"
}

class ThreadTransitionViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var timerLabel: UILabel!
    
    // customize thread print
    let operationThread = OperationQueue().then {
        $0.name = "Thread (Qos: default)"
        $0.qualityOfService = .default
    }
    
    var disposeBag = DisposeBag()
    var cancelBag = CancelBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.timerLabel.text = "\(Date().timeIntervalSince1970 * 1000)"
        }
    }
    
    // Fire button을 누르고 이미지가 로딩될 때까지(UI Thread), Timer(백그라운드)가 멈추는 현상 발생
    // Thread 분리
    @IBAction func onFire(_ sender: Any) {
        print("--")

//        operationThread.addOperation {
//            let url = URL(string: IMAGE_URL)!
//            print("[1] : \(currentThreadName())")
//            let data = try! Data(contentsOf: url)
//            let image = UIImage(data: data)
//
//            OperationQueue.main.addOperation { [weak self] in
//                print("[2] : \(currentThreadName())")
//                self?.imageView.image = image
//            }
//        }
        
        // 위의 표현식을 RxSwift로 간소화
        Observable.just(IMAGE_URL)
            .do(onNext: { _ in print("[1] : \(currentThreadName())")})
            .map{ URL(string: $0)! }
            .map{ try! Data(contentsOf: $0) }
            .map{ UIImage(data: $0) }
            .subscribeOn(OperationQueueScheduler(operationQueue: operationThread)) // upstream에 영향을 줘서 url로부터 데이터를 읽고 image로 변환하는 작업은 백그라운드에서
            .observeOn(MainScheduler.instance) // UI에 붙이는 다음 작업은 downstream
            .do(onNext: { _ in print("[2] : \(currentThreadName())")})
            .bind(to: imageView.rx.image)
            .disposed(by: disposeBag)
        
        // RxSwift to Combine
        Just(IMAGE_URL)
            .handleEvents(receiveOutput: { _ in print("[1] : \(currentThreadName())")})
            .map{ URL(string: $0)! }
            .tryMap{ try! Data(contentsOf: $0) }
            .map{ UIImage(data: $0) }
            .replaceError(with: nil)
            // UI 작업하기 전에
            .subscribe(on: operationThread)
            .receive(on: OperationQueue.main)
            .handleEvents(receiveOutput: { _ in print("[2] : \(currentThreadName())")})
            .assign(to: \.image, on: imageView)
            .cancel(with: cancelBag)
    }
}
