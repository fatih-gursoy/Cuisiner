//
//  ViewController.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 7.03.2022.
//

import UIKit

class WelcomeVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        
        let signUpView = SignUpVC()
        signUpView.delegate = self
        present(signUpView, animated: true)
        
    }
    
    @IBAction func logInClicked(_ sender: Any) {
        
        let signInView = SignInVC()
        signInView.delegate = self
        present(signInView, animated: true)

    }
    
    func toHomeVC() {
        performSegue(withIdentifier: "toHomeVC", sender: nil)
    }
    
}

extension WelcomeVC: SignInDelegate, SignUpDelegate {

    func didUserSignIn() {
        dismiss(animated: true)
        toHomeVC()
    }
    
    func didUserSignUp() {
        dismiss(animated: true)
        toHomeVC()
    }
    
    
    
}

