//
//  AsyncWrapping.swift
//  RxSwiftStudy
//
//  Created by jaekyung you on 2020/12/18.
//

import UIKit
import RxSwift
import RxCocoa

import Combine

class AsyncWrappingViewController: UIViewController {
    
    var disposeBag = DisposeBag()
    var cancellable : Cancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    func delayJob(_ job: @escaping (String) -> Void) {
        self.activity.isHidden = false
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            DispatchQueue.main.async {
                self.activity.isHidden = true
                job("Hi!")
            }
        }
    }
    
    // RxSwift
    func rxDelayJob() -> Observable<String>{
        return Observable.create{ emitter in
            self.delayJob {
                emitter.onNext($0)
                emitter.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    
    // Combine
    func comebineDelayJob() -> AnyPublisher<String?, Never>{
        return Future<String?, Never> { promise in
            self.delayJob{ promise(.success($0))}
        }.eraseToAnyPublisher()
    }
    
    // MARK: - UI
    @IBOutlet weak var textLabel: UILabel!
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    @IBAction func onFire(_ sender: Any) {
//        delayJob { self.textLabel.text = $0 }
        
        // RxSwift
//        rxDelayJob().bind(to: textLabel.rx.text)
//            .disposed(by: disposeBag)
        
        // Combine
//        cancellable = comebineDelayJob().assign(to: \.text, on: textLabel)
        
        // 기존의 비동기함수를 Observable로 표현
        /*
        Observable.just("Hi!")
            .do(onNext: { _ in self.activity.isHidden = false })
            .delay(.seconds(1), scheduler: MainScheduler.instance)
            .do(onNext: { _ in self.activity.isHidden = true })
            .bind(to: textLabel.rx.text)
            .disposed(by: disposeBag)
         */
        
        // 기존의 비동기함수를 Publisher로 표현
        cancellable = Just("Hi!")
            .handleEvents(receiveOutput: { _ in  self.activity.isHidden = false })
            .delay(for: 1, scheduler: RunLoop.main)
            .handleEvents(receiveOutput: { _ in  self.activity.isHidden = true })
            .assign(to: \.text, on: textLabel)
            
        
    }
}
