//
//  SignInVC.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 9.03.2022.
//

import UIKit
import Firebase

class SignInVC: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var passwordAgainText: UITextField!
    
    weak var signInDelegate: SignInDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func signInClicked(_ sender: Any) {
        
        if emailText.text != nil && passwordText.text != nil {
            
            if passwordText.text == passwordAgainText.text {
                
                signIn(emailText.text!, passwordText.text!)
            }
            
        } else {
            
            //Make Alert
        }
    }
    
    
    func signIn(_ email: String,_ password: String) {
        
        let userAuth = Auth.auth()
        
        userAuth.createUser(withEmail: email, password: password) { authData, error in
            
            if error != nil {
                print(error?.localizedDescription as Any)
            } else {
                self.signInDelegate?.didUserSignIn()
            }
        }
    }
    
}


protocol SignInDelegate: AnyObject {
    
    func didUserSignIn()
    
}
