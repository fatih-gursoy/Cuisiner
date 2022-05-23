//
//  SigninVC.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 8.03.2022.
//

import UIKit

class SignInVC: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    weak var delegate: SignInDelegate?
    
    private var authManager = AuthManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboard()
    }

    @IBAction func signInClicked(_ sender: Any) {
        
        if emailText.text != nil && passwordText.text != nil {
            
            authManager.updateCredentials(email: emailText.text!,
                                          password: passwordText.text!)
            
            authManager.signIn { [weak self] success in
                if (success) {
                      self?.delegate?.didUserSignIn()
                } else {
                    if let errorMessage = self?.authManager.errorMessage {
                          self?.presentAlert(title: "Error", message: errorMessage)
                    }
                }
            }
        } else {
            presentAlert(title: "Couldn't Sign In", message: "Please fill credentials")
        }
    }
    
        
}

protocol SignInDelegate: AnyObject {
    
    func didUserSignIn()
}
