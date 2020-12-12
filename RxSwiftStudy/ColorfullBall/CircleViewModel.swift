//
//  CircleViewModel.swift
//  RxSwiftStudy
//
//  Created by jaekyung you on 2020/12/12.
//

import Foundation
import ChameleonFramework
import RxSwift
import RxCocoa
import NSObject_Rx

// ViewModel에서 bind()할 차례

class CircleViewModel {
    
    //원의 위치와 원의 색 변수 선언
    var centerValue = BehaviorRelay<CGPoint?>(value: .zero) // 원의 가장 최근 중앙 지점만 필요
    // ~Relay는 .completed/.error없이 UI Event에 적합
    
    // var centerObservable = BehaviorSubject<CGPoint?>(value: .zero)
    var backgroundColorObservable: Observable<UIColor>!
    
    init(){
        setUp()
    }
    
    func setUp() {
        // 새로운 중앙값을 받으면, 새로운 color 방출
        
        backgroundColorObservable = centerValue.asObservable() // Observable로 형 변환
            .map { center in
                guard let center = center else { return UIColor.flatten(.black)() } // <CGPoint?>이므로 nil을 대비해서 default color = black
                let red: CGFloat = ((center.x + center.y).truncatingRemainder(dividingBy: 255.0)) / 255.0 // We just manipulate red
                let green: CGFloat = 0.0
                let blue: CGFloat = 0.0
                
                return UIColor.flatten(UIColor(red: red, green: green, blue: blue, alpha: 1))() // CGPoint -> UIColor
            }
    }
    
}
