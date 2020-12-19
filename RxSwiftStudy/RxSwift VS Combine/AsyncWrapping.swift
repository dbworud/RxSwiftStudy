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
//        rxDelayJob().bind(to: textLabel.rx.text)
//            .disposed(by: disposeBag)
        cancellable = comebineDelayJob().assign(to: \.text, on: textLabel)
        
    }
}
