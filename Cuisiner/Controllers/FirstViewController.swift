//
//  ViewController.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 7.03.2022.
//

import UIKit

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    @IBAction func signUpClicked(_ sender: Any) {
        
        let signInView = SignInVC()
        signInView.signInDelegate = self
        present(signInView, animated: true)
        
    }
    
    @IBAction func logInClicked(_ sender: Any) {
        
        let loginView = LoginVC()
        loginView.loginDelegate = self
        present(loginView, animated: true)

    }
    
    func toHomeVC() {
     
        performSegue(withIdentifier: "toHomeVC", sender: nil)
        
    }
    
}

extension FirstViewController: SignInDelegate, LoginDelegate {

    func didUserSignIn() {
    
        dismiss(animated: true)
        toHomeVC()
    }
    
    func userDidLogin() {
        
        dismiss(animated: true)
        toHomeVC()
    }
    
    
    
}

