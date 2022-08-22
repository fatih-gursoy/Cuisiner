//
//  ViewController.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 7.03.2022.
//

import UIKit

class WelcomeVC: UIViewController, Storyboardable {
    
    weak var coordinator: AuthCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        coordinator?.gotoSignUp(delegate: self)
    }
    
    @IBAction func logInClicked(_ sender: Any) {
        coordinator?.gotoSignIn(delegate: self)
    }
    
    func toHomeVC() {
        coordinator?.gotoTabbar()
    }
    
}

extension WelcomeVC: SignInDelegate, SignUpDelegate {

    func didUserSignIn() {
        dismiss(animated: true) { [weak self] in
            self?.toHomeVC()
        }
    }
    
    func didUserSignUp() {
        dismiss(animated: true) { [weak self] in
            self?.toHomeVC()
        }
    }
}

