//
//  PasswordEnterVC.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 6.08.2022.
//

import UIKit

class AccountDeleteVC: UIViewController {
    
    @IBOutlet private weak var passwordField: UITextField!
    private var authManager = AuthManager.shared
    var viewModel: UserViewModel?
    weak var delegate: ProfileEditVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func confirmTapped(_ sender: Any) {
        
        guard let password = passwordField.text else { return }
        viewModel?.deleteAllUserData(completion: { [weak self] success in
            if success {
                self?.authManager.deleteAccount(password: password) { success in
                    if success {
                        self?.presentAlert(title: "Your account was deleted", message: "", completion: { _ in self?.routeToWelcomeVC() })
                    } else {
                        if let error = self?.authManager.errorMessage {
                            self?.presentAlert(title: "Error", message: error, completion: nil)
                        }
                    }
                }
            }
        })
        
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    func routeToWelcomeVC() {
        self.dismiss(animated: true) {
            self.delegate?.gotoWelcome()
        }
    }
}
