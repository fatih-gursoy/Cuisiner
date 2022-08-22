//
//  AuthCoordinator.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 21.08.2022.
//

import Foundation
import UIKit

class AuthCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    weak var parentCoordinator: AppCoordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let welcomeVC = WelcomeVC.instantiateFromStoryboard()
        navigationController.pushViewController(welcomeVC, animated: false)
        welcomeVC.coordinator = self
    }
    
    func gotoTabbar() {
        parentCoordinator?.gotoTabBar()
        parentCoordinator?.childDidFinish(self)
    }
    
    func gotoSignIn(delegate: SignInDelegate) {
        let signInVC = SignInVC()
        signInVC.delegate = delegate
        navigationController.present(signInVC, animated: true)
    }
    
    func gotoSignUp(delegate: SignUpDelegate) {
        let signUpVC = SignUpVC()
        signUpVC.delegate = delegate
        navigationController.present(signUpVC, animated: true)
    }
    
    
}
