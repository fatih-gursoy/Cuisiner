//
//  SignUpVC.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 9.03.2022.
//

import UIKit
import Firebase

class SignUpVC: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var passwordAgainText: UITextField!
    
    weak var delegate: SignUpDelegate?
    var userViewModel = UserViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboard()

    }

    
    @IBAction func signUpClicked(_ sender: Any) {
        
        if emailText.text != "" && passwordText.text != "" {
        
            if passwordText.text == passwordAgainText.text {
                
                userViewModel.updateCredentials(email: emailText.text!,
                                                  password: passwordText.text!)
                
                userViewModel.signUp { [weak self] success in
                    if (success) {
                        self?.delegate?.didUserSignUp()
                    } else {
                        if let errorMessage = self?.userViewModel.errorMessage {
                            self?.presentAlert(title: "Error", message: errorMessage)
                        }
                    }
                }
            } else {
                presentAlert(title: "Couldn't Sign Up", message: "Password fields don't match")
            }
        } else {
            presentAlert(title: "Couldn't Sign Up", message: "Please fill credentials")
        }

    }
    
}

protocol SignUpDelegate: AnyObject {
    
    func didUserSignUp()
}
