//
//  ColorfullBallController.swift
//  RxSwiftStudy
//
//  Created by jaekyung you on 2020/12/12.
//

import UIKit
import ChameleonFramework
import RxCocoa
import RxSwift


class CircleViewController : UIViewController {
    
    var circleView: UIView!
    
    let circleViewModel = CircleViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    
    func setUp() {
        // 원모양 생성
        circleView = UIView(frame: CGRect(origin: view.center, size: CGSize(width: 100.0, height: 100.0)))
        circleView.layer.cornerRadius = circleView.frame.width / 2
        circleView.center = view.center
        circleView.backgroundColor = . green
        view.addSubview(circleView)
        
        // 1. CircleView의 중앙지점을 ViewModel의 centerValue와 바인딩
        circleView
            .rx.observe(CGPoint.self, "center") // using RxCocoa
            .bind(to: circleViewModel.centerValue)
            .disposed(by: rx.disposeBag)
        
        
        // 2. 원의 배경색과 뷰의 배경색을 바꾸는 logic을 구독
        circleViewModel.backgroundColorObservable
            .subscribe(onNext: { [weak self] backgroundColor in // nil일 수도 있음을 가정
                self?.circleView.backgroundColor = backgroundColor
                
                // 원과 배경의 색을 상호보완적으로
                let viewBackgroundColor = UIColor(complementaryFlatColorOf: backgroundColor)
                
                // 기존의 색과 다르면, 새로운 배경 색으로 할당
                if viewBackgroundColor != backgroundColor {
                    self?.view.backgroundColor = viewBackgroundColor
                }
            })
            .disposed(by: rx.disposeBag)
        
        // pan gesture recognizer 추가
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(circleMoved(_:)))
        circleView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func circleMoved(_ recognizer: UIPanGestureRecognizer) {
        // 위치 상수 설정
        let location = recognizer.location(in: view)
        UIView.animate(withDuration: 0.1) {
            self.circleView.center = location
        }
    }
    
}
