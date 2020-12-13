# RxSwift
- Observable들의 Sequence를 이용하여 비동기적 처리 및 이벤트/데이터 스트림을 구현
- 상태의 변화에 따른 대응, 이벤트들의 순서 구성, 코드 분리, 재사용성 향상

## 1. Observables(= Observable sequence, Sequence)
Rx코드 기반으로 T형태의 데이터를 전달할 수 있는 이벤트들을 비동기적으로 생성  
Observer가 구독할 수 있게끔 이벤트를 생성(emit)하는 것   
생명주기
1. next이벤트를 통해 값 방출
2. 값이 온전히 방출되면 completed 이벤트 발생하고 종료
3. 값이 온전히 방출되지 못하면 error 이벤트 발생하고 종료
Observable은 sequence의 정의일뿐, 구독(subscribe)되기 전에는 아무러 이벤트 발생X

### Trait 일반적인 Observable보다 좁은 범위의 Observable
- Single: **.success(value)(= .next + .completed)** 나 **.error** 이벤트 방출
- Completable: **.completed**나 **.error**만 방출 + 값 방출X
- May: **.success(value), .completed, .error + 값** 방출 

## 2. Operators
ObservableType과 Observable클래스에서 복잡한 논리를 구현하기 위한 메소드
ex. filter, map, ... , -> subscribe 때 비로소 구독하면서 값을 방출 

## 3. Schedulers
RxSwift에는 여러 스케줄러가 정의되어 있으며, 더 나은 performance를 위해 동일한 subscribe 작업 안에 다른 스케줄러에서 스케줄링이 가능

![image](https://user-images.githubusercontent.com/59492694/102000834-de29bf80-3d2e-11eb-9c39-427aa401629b.png)

## 4. Subject = Observable이자 Observer
Observable에 값을 추가하고 Subscribe까지 하는 것
- PublishSubject : subscribe() ~ .completed/.error 초기값X   ex. 친구의 선물 언박싱에 늦어서 지난 선물을 모름
- BehaviorSubject : subscribe()직전 ~ .completed/.error 초기값O ex. 친구가 바로 직전에 뜯은 선물만 말해줌
- ReplaySubject : 특정 크기만큼 일시적으로 캐시/버퍼 저장해서 최신 요소만 방출 ex. 친구가 직전에 뜯은 3개의 선물까지만 말해줌, 최근 검색어

# RxCocoa
RxSwift는 일반적인 Rx API이고, RxCocoa는 RxSwift의 동반 라이브러리로서 UIKit와 Cocoa프레임워크 기반의 개발을 지원하는 클래스를 보유하고 있음
Relay는 RxCocoa4에서 구현된 클래스
- PublishRelay: PublishSubject의 Wrapper
- BehaviorRelay: BehaviorSubject의 Wrapper, .value를 통해 현재값 가져올 수 있음 (~~Variable~~ -> BehaviorRelay)
~ Subject는 .completed/.error 이벤트가 발생되어 subscribe종료  
~ Relay는 .completed/.error 이벤트가 발생하지 않고 수동으로 dispose되기 전까지 계속 작동하 -> UI Event에 적합
