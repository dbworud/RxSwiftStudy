//
//  ArticleCell.swift
//  RxSwiftStudy
//
//  Created by jaekyung you on 2021/01/21.
//

import UIKit
import RxSwift
import SDWebImage

class ArticleCell: UICollectionViewCell {
    
    // MARK: Properties
    var viewModel = PublishSubject<CellViewModel>()
    
    let disposeBag = DisposeBag()
    
    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 8
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.widthAnchor.constraint(equalToConstant: 60).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 60).isActive = true
        iv.backgroundColor = .secondarySystemBackground // image nil인 경우
        return iv
    }()
    
    private lazy var titleLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 3
        return label
    }()
    
    // MARK: LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        subscribe()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Configure
    func configureUI(){
        backgroundColor = .systemBackground
        
        [imageView, titleLabel, descriptionLabel].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.topAnchor),
            titleLabel.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 20),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -40),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            descriptionLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor),
            descriptionLabel.rightAnchor.constraint(equalTo: titleLabel.rightAnchor)
        ])
    }
    
    // MARK: Helper
    func subscribe() {
        self.viewModel.subscribe(onNext:{ cellViewModel in
            if let imageUrl = cellViewModel.imageUrl {
                self.imageView.sd_setImage(with: URL(string: imageUrl), completed: nil)
            }
            
            self.titleLabel.text = cellViewModel.title
            self.descriptionLabel.text = cellViewModel.description
        })
        .disposed(by: disposeBag)
    }
}
