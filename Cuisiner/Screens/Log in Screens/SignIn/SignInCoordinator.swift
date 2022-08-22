//
//  SignInCoordinator.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 22.08.2022.
//

import Foundation
import UIKit

class SignInCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    weak var parentCoordinator: AuthCoordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start(delegate: SignInDelegate) {
        let signInVC = SignInVC()
        signInVC.delegate = delegate
        signInVC.coordinator = self
        navigationController.pushViewController(signInVC, animated: false)
    }
    
    func gotoResetPassword(email: String, delegate: ResetPasswordVCDelegate) {
        let resetPasswordVC = ResetPasswordVC(message: "Email will be sent to \(email) \n \n Are you sure?")
        resetPasswordVC.delegate = delegate
        resetPasswordVC.coordinator = self
        resetPasswordVC.navigationItem.title = "Reset Password"
        navigationController.pushViewController(resetPasswordVC, animated: true)
    }
    
    func didFinish() {
        parentCoordinator?.childDidFinish(self)
    }
    
}
