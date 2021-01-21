//
//  ArticleViewController.swift
//  RxSwiftStudy
//
//  Created by jaekyung you on 2021/01/21.
//

import UIKit
import RxSwift

class ArticleViewController: UIViewController {
    
    // 생성자를 사용하는 이유는 의존성 주입 패턴으로 구현
    let viewModel: ArticleViewModel
    
    let disposeBag = DisposeBag()
    
    init(viewModel: ArticleViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    
        fetchArticles()
    }
    
    func configureUI() {
        view.backgroundColor = .systemBackground
    }
    
    func fetchArticles() {
        self.viewModel.fetchArticles() // Observable 형태의 article = event
            .subscribe(onNext: { articles in // 구독 시작, 이벤트 방출
                print(articles)
            })
            .disposed(by: disposeBag)
    }
    

}
