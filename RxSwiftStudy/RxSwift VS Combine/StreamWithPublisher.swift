//
//  StreamWithPublisher.swift
//  RxSwiftStudy
//
//  Created by jaekyung you on 2020/12/18.
//

import UIKit
import RxCocoa
import RxSwift

import Combine

class StreamViewController: UIViewController {
    
    var disposeBag = DisposeBag()
    
    var cancellable : Cancellable?
    @Published var publishedValue: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // RxSwift
    func rxAsyncTask() -> Observable<String?> {
        return Observable.create{ emitter in
            self.doAsyncTask { t in
                guard let tt = t else {
                    emitter.onNext(t)
                    emitter.onCompleted()
                    return
                }
                emitter.onNext(tt)
            }
            return Disposables.create()
        }
    }
    
    // Combine
    func combineAyncTask() -> AnyPublisher<String?, Never> {
        doAsyncTask { t in
            self.publishedValue = t
        }
        return $publishedValue.eraseToAnyPublisher()
    }

    func doAsyncTask(_ task: @escaping (String?) -> Void) {
        task("3")
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            task("2")
            DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                task("1")
                DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                    task("Hi!")
                    DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                        task(nil) // end
                    }
                }
            }
        }
    }
    
    // MARK: - UI
    @IBOutlet weak var textLabel: UILabel!
    
    @IBAction func onFire(_ sender: Any) {
        /*
        doAsyncTask { t in
            DispatchQueue.main.async {
                self.textLabel.text = t // UI thread
            }
        }
        */
        
        // RxSwift
        rxAsyncTask()
            .observeOn(MainScheduler.instance)
            .bind(to: textLabel.rx.text)
            .disposed(by: disposeBag)
        
        // RxSwift to Combine
        cancellable = combineAyncTask()
            .receive(on: RunLoop.main)
            .assign(to: \.text, on: textLabel)
        
    }
}

