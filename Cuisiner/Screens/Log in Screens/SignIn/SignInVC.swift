//
//  SigninVC.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 8.03.2022.
//

import UIKit

protocol SignInDelegate: AnyObject {
    func didUserSignIn()
}

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
                    self?.rememberMe()
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
    
    @IBAction func forgotPasswordTapped(_ sender: Any) {
        
        if let email = emailText.text, email != "" {
            let alertVC = ResetPasswordVC(message: "Email will be sent to \(email) \n \n Are you sure?")
            alertVC.delegate = self
            self.navigationController?.pushViewController(alertVC, animated: true)
        } else {
            presentAlert(title: "Please enter a valid email", message: "", completion: nil)
        }
    }
    
    func configureUI() {
        if defaults.isRemember {
            rememberMeSwitch.isOn = true
            emailText.text = defaults.email
        }
    }
    
    func rememberMe() {
        if rememberMeSwitch.isOn {
            defaults.setData(isRemember: true,
                             email: emailText.text!)
        } else {
            defaults.removeUserLoginData()
        }
    }
}

extension SignInVC: ResetPasswordVCDelegate {
   
    func OkAction(completion: @escaping (Bool) -> Void) {
        guard let email = emailText.text else {return}
        
        authManager.passwordReset(email: email) { [weak self] success in
            if success {
                completion(success)
            } else {
                guard let error = self?.authManager.errorMessage else {return}
                self?.presentAlert(title: "\(error)", message: "", completion: { _ in
                    completion(false)
                })
            }
        }
    }
}
