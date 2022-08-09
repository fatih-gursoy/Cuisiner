//
//  ViewController+Extension.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 30.03.2022.
//

import Foundation
import UIKit

extension UIViewController {
    
    func presentAlert(title: String, message: String, completion: ( (UIAlertAction) -> Void)? ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertButton = UIAlertAction(title: "Ok", style: .default, handler: completion)
        alert.addAction(alertButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    func presentQuickAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.dismiss(animated: true)
        }
        
    }
    
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
        
// MARK: - Keyboard manuel handling
//    IQKeyboardManager library was used in project instead of..
    
//    func keyboardNotification(scrollView: UIScrollView) {
//        
//        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification,
//                                               object: nil, queue: nil) { notification in
//            
//            guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]
//                                      as? NSValue)?.cgRectValue else {return}
//            
//            let bottom = keyboardSize.height
//            scrollView.contentInset.bottom = bottom
//        }
//        
//        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification,
//                                               object: nil, queue: nil) { notification in
//            scrollView.contentInset.bottom = .zero
//        }
//    }
    
}

