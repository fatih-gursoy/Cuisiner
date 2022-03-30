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
    var userViewModel = UserViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboard()
    }

    @IBAction func signInClicked(_ sender: Any) {
        
        if emailText.text != nil && passwordText.text != nil {
                           
            userViewModel.updateCredentials(email: emailText.text!,
                                              password: passwordText.text!)
            
            userViewModel.signIn { [weak self] success in
            
                if (success) {
                    self?.delegate?.didUserSignIn()
                } else {
                    if let errorMessage = self?.userViewModel.errorMessage {
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
