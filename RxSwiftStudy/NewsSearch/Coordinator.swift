//
//  Coordinator.swift
//  RxSwiftStudy
//
//  Created by jaekyung you on 2021/01/21.
//

import UIKit


class Coordinator {
    
    let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let rootViewController = ArticleViewController(viewModel: ArticleViewModel(articleService: ArticleService()))
        let navigationController = UINavigationController(rootViewController: rootViewController)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
}
