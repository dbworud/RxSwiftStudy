//
//  EditingChanged.swift
//  RxSwiftStudy
//
//  Created by jaekyung you on 2020/12/19.
//

/*
 TextField에서 editingChange 이벤트를 처리하는 코드
 1. .addTarget
 2. RxSwift
 3. Combine
 
 */

import UIKit
import RxSwift
import RxCocoa

import Combine

class EditingChangedViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var validLabel: UILabel!
    
    // RxSwift
    var disposeBag = DisposeBag()
    
    // Combine
    @Published var emailText: String = ""
    var cancellable: Cancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        bindEvent()
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        return NSPredicate(format: "SELF MATCHES %@", pattern)
            .evaluate(with: email)
    }
    
    
    func bindEvent() {
        emailField.addTarget(self, action: #selector(onChange(_:)), for: .editingChanged)
//        validLabel.isHidden = true
        
        /* RxSwift
        emailField.rx.text.orEmpty
            .map { $0.isEmpty ? true: self.isValidEmail($0)}
            .bind(to: validLabel.rx.isHidden)
            .disposed(by: disposeBag)
        */
        
        // Combine
        cancellable = $emailText
            .map{ $0.isEmpty ? true : self.isValidEmail($0)}
            .sink(receiveValue: { self.validLabel.isHidden = $0} )
        validLabel.isHidden = true
    }
    
    @objc func onChange(_ field: UITextField) {
        let text = field.text ?? ""
        let isValid = text.isEmpty ? true : isValidEmail(text)
        validLabel.isHidden = isValid
    }
}
