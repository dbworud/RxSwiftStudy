//
//  SubjectOfCombine.swift
//  RxSwiftStudy
//
//  Created by jaekyung you on 2020/12/18.
//

/*
 PassthroughSubject = PublishSubject 초기값 없음
 CurrentValueSubject = BehaviorSubject 초기값 있음
 
 !!중요
 Combine에서 구독하고 반환되는 cancellable을 로컬 변수에 담아놓으면
 로컬변수가 scope를 벗어나면서 삭제되고 stream도 함께 취소
 따라서, stream을 살려두려면 cancellable 인스턴스를 어딘가에 보관할 필요가 있다
 */

import Foundation
import RxSwift
import RxCocoa

import Combine
import CancelBag

class SubjectViewController: UIViewController {
    
    var value = 0{
        didSet {
            // value 값을 noti에 넣어 날림
            // NotificationCenter.default.post(name: .init("value"), object: value)
            
            // RxSwift
//            behaviorStream.onNext(value)
            
            // Combine
            currentvalue.send(value)
        }
    }
     
    // RxSwift
    let publishStream = PublishSubject<Int>()
    let behaviorStream = BehaviorSubject<Int>(value: 0) // - 없이 0부터 혹은 숫자로 바로 나옴
    
    // Combine
    let passthrough = PassthroughSubject<Int, Never>()
    let currentvalue = CurrentValueSubject<Int, Never>(0)
    
    var cancellable : [Cancellable] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func createAndAddLabel() {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30, weight: .medium)
        label.text = "-"
        label.textAlignment = .center
        label.heightAnchor.constraint(equalToConstant: 40).isActive = true
        stackView.insertArrangedSubview(label, at: 0)
        
        /*
        // Noti에 observer추가
        NotificationCenter.default.addObserver(forName: .init("value"), object: nil, queue: OperationQueue.main) { (noti) in
            if let v = noti.object as? Int {
                label.text = "\(v)"
            }
        }
        */
        
        // 위를 RxSwift로
        _ = behaviorStream.map{ "\($0)" }
            .bind(to: label.rx.text)
        
        // RxSwift to Combine
        let p = passthrough.map{ "\($0)" }
            .assign(to: \.text, on: label)
        
        let c = currentvalue.map{ "\($0)" }
            .assign(to: \.text, on: label)
        
        cancellable.append(c)
        
    }
    
    // MARK: - UI
    @IBOutlet weak var stackView: UIStackView!
    
    @IBAction func onAddItem(_ sender: Any) {
        createAndAddLabel()
    }
    
    @IBAction func onIncrease(_ sender: Any) {
        value += 1
    }
}
