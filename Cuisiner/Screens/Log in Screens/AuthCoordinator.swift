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
        navigationController.setViewControllers([welcomeVC], animated: true)
        welcomeVC.coordinator = self
    }
    
    func childDidFinish(_ child: Coordinator) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child { childCoordinators.remove(at: index) }
        }
    }
    
    func gotoTabbar() {
        parentCoordinator?.gotoTabBar()
        parentCoordinator?.childDidFinish(self)
    }
    
    func gotoSignIn(delegate: SignInDelegate) {
        let signInNavigation = UINavigationController()
        let signInCoordinator = SignInCoordinator(navigationController: signInNavigation)
        signInCoordinator.parentCoordinator = self
        childCoordinators.append(signInCoordinator)
        signInCoordinator.start(delegate: delegate)
        navigationController.present(signInNavigation, animated: true)
    }
    
    func gotoSignUp(delegate: SignUpDelegate) {
        let signUpVC = SignUpVC()
        signUpVC.delegate = delegate
        navigationController.present(signUpVC, animated: true)
    }
    
}
