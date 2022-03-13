//
//  LoginVC.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 8.03.2022.
//

import UIKit
import Firebase

class LoginVC: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    weak var loginDelegate: LoginDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }


    @IBAction func logInClicked(_ sender: Any) {
        
        if emailText.text != nil && passwordText.text != nil {
                
            logIn(emailText.text!, passwordText.text!)
            
        } else {
            
            //Make Alert
        }
    }
        
    
    
    
    func logIn(_ email: String,_ password: String) {
        
        let userAuth = Auth.auth()
        userAuth.signIn(withEmail: email, password: password) { authData, error in
            
            if error != nil {
                print(error?.localizedDescription as Any)
            } else {
                
                self.loginDelegate?.didUserLogin()
                
            }
        }
    }

}


protocol LoginDelegate: AnyObject {
    
    func didUserLogin()
}
