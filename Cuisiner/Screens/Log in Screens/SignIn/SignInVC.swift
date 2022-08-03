//
//  SigninVC.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 8.03.2022.
//

import UIKit

class SignInVC: UIViewController {

    @IBOutlet private weak var emailText: UITextField!
    @IBOutlet private weak var passwordText: UITextField!
    @IBOutlet private weak var rememberMeSwitch: UISwitch!
    
    private var defaults = UserDefaults.standard
    weak var delegate: SignInDelegate?
    
    private var authManager = AuthManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
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
                        self?.presentAlert(title: "Error", message: errorMessage, completion: nil)
                    }
                }
            }
        } else {
            presentAlert(title: "Couldn't Sign In", message: "Please fill credentials", completion: nil)
        }
    }
    
    @IBAction func switchTapped(_ sender: Any) {
            
        if rememberMeSwitch.isOn {
            defaults.setData(isRemember: true,
                             email: emailText.text!,
                             password: passwordText.text!)
        } else {
            defaults.removeUserLoginData()
        }
    }
    
    func configureUI() {
        if defaults.isRemember {
            rememberMeSwitch.isOn = true
            emailText.text = defaults.username
            passwordText.text = defaults.password
        }
    }
    
}

protocol SignInDelegate: AnyObject {
    func didUserSignIn()
}
