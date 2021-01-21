//
//  ArticleViewController.swift
//  RxSwiftStudy
//
//  Created by jaekyung you on 2021/01/21.
//

import UIKit
import RxSwift
import RxRelay // articles를 subscribe하기 위해

class ArticleViewController: UIViewController {
    
    // 생성자를 사용하는 이유는 의존성 주입 패턴으로 구현
    let viewModel: ArticleViewModel
    
    let disposeBag = DisposeBag()

    private let cellViewModel = BehaviorRelay<[CellViewModel]>(value: []) // 변화를 update
    
    var cellViewModelObserver : Observable<[CellViewModel]>{
        return cellViewModel.asObservable() // cell이 변할 때마다 감지
    }
    
    private lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout())
        
        cv.delegate = self
        cv.dataSource = self
        
        cv.backgroundColor = .systemBackground
        
        return cv
    }()
    
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
        subscribe()
    }
    
    func configureUI() {
        view.backgroundColor = .systemBackground
        
        self.title = self.viewModel.title
        
        collectionView.register(ArticleCell.self, forCellWithReuseIdentifier: "cell")
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
    
    func fetchArticles() {
        viewModel.fetchArticles().subscribe(onNext:{ cellViewModels in
            self.cellViewModel.accept(cellViewModels)
        })
        .disposed(by: disposeBag)
        
    }
    
    func subscribe() {
        self.cellViewModelObserver.subscribe(onNext: { articles in
//            print(articles)
            DispatchQueue.main.async {
                self.collectionView.reloadData() // cell이 변할 때마다 CollectionView reload
            }
        })
        .disposed(by: disposeBag)
    }

}

extension ArticleViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cellViewModel.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ArticleCell
        
        cell.imageView.image = nil // image 겹칠 수 있기때문에 nil로 초기화
        let cellViewModel = self.cellViewModel.value[indexPath.row]
        cell.viewModel.onNext(cellViewModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }
    
}
