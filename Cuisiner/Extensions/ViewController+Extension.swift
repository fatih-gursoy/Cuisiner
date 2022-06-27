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
    
    func hideKeyboard() {
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    

    
    
}

