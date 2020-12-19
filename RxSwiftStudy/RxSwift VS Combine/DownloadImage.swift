//
//  DownloadImage.swift
//  RxSwiftStudy
//
//  Created by jaekyung you on 2020/12/19.
//

/*
 이미지 다운로드하는 법
 1. Closure
 2. RxSwift
 3. Combine
*/

import UIKit
import RxSwift
import RxCocoa

import Combine

class DownloadViewController: UIViewController {
    
    let IMAGE_URL = "https://picsum.photos/1024"
    var task : URLSessionTask?
    // RX
    var disposable: Disposable?
    
    // Combine
    var cancellable: Cancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onLoadImage(_ sender: Any) {
        self.indicator.isHidden = false // load시에 보이도록
        
        /* 1. Closure
        task = loadImageWithClosure(url: IMAGE_URL) { image in
            DispatchQueue.main.async {
                self.imageView.image = image
                self.indicator.isHidden = true
            }
        }
        */
        
        /* 2. RxSwift
        disposable = loadImageWithRx(url: IMAGE_URL)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {
                self.imageView.image = $0
            }, onCompleted: {
                self.indicator.isHidden = true
            })
         */
        
        // Combine
        cancellable = loadImageWithCombine(url: IMAGE_URL)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { _ in
                self.indicator.isHidden = true
            }, receiveValue: {
                self.imageView.image = $0
            })
        
    }
    
    @IBAction func onCancel(_ sender: Any) {
//        task?.cancel()
//        disposable?.dispose()
        cancellable?.cancel()
        
        imageView.image = nil
        indicator.isHidden = true
    }

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    // 1. Closure
    func loadImageWithClosure(url: String, completion: @escaping (UIImage?) -> Void) -> URLSessionTask {
        let task = URLSession.shared.dataTask(with: URL(string: url)!) { data, _, _ in
            guard let data = data else {
                completion(nil)
                return
            }
            let image = UIImage(data: data)
            completion(image)
        }
        
        task.resume()
        return task
    }
    
    // 2. RxSwift
    func loadImageWithRx(url: String) -> Observable<UIImage?> {
        return Observable.create { emitter in
            
            let task = URLSession.shared.dataTask(with: URL(string: url)!) { data, _, _ in
                guard let data = data else {
                    emitter.onNext(nil)
                    emitter.onCompleted()
                    return
                }
                let image = UIImage(data: data)
                emitter.onNext(image)
                emitter.onCompleted()
            }
            
            task.resume()
            return Disposables.create{
                task.cancel()
            }
        }
    }
    
    // 3. Combine
    func loadImageWithCombine(url: String) -> AnyPublisher<UIImage?, Error> {
        return URLSession.shared.dataTaskPublisher(for: URL(string: url)!)
            .map{ UIImage(data: $0.data) }
            .mapError{ $0 as Error }
            .eraseToAnyPublisher()
        
    }
}
