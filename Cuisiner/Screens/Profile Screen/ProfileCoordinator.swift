//
//  ProfileCoordinator.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 22.08.2022.
//

import Foundation
import UIKit

class ProfileCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    weak var parentCoordinator: AppCoordinator?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start(viewModel: UserViewModel) {
        let profileVC = ProfileVC.instantiateFromStoryboard()
        profileVC.coordinator = self
        profileVC.viewModel = viewModel

        navigationController.modalPresentationStyle = .fullScreen
        navigationController.pushViewController(profileVC, animated: false)
    }
 
    func gotoProfileEdit(viewModel: UserViewModel) {
        let profileEditVC = ProfileEditVC.instantiateFromStoryboard()
        profileEditVC.viewModel = viewModel
        profileEditVC.coordinator = self
        navigationController.pushViewController(profileEditVC, animated: true)
    }
    
    func gotoBlockedUsers() {
        let blockedUsersVC = BlockedUsersVC.instantiateFromStoryboard()
        blockedUsersVC.coordinator = self
        navigationController.pushViewController(blockedUsersVC, animated: true)
    }
    
    func didFinished() {
        parentCoordinator?.childDidFinish(self)
        navigationController.dismiss(animated: true)
    }
    
    func logOut() {
        navigationController.dismiss(animated: true)
        parentCoordinator?.childCoordinators.removeAll()
        parentCoordinator?.gotoAuth()
    }
    
}


    
