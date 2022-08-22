//
//  TabBarCoordinator.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 21.08.2022.
//

import Foundation
import UIKit

class TabBarCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    weak var parentCoordinator: AppCoordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let tabBarVC = TabBarVC.instantiateFromStoryboard()
        tabBarVC.coordinator = self
        navigationController.pushViewController(tabBarVC, animated: true)
        navigationController.setNavigationBarHidden(true, animated: true)
    }
    
    func startCreateNewVC() {
        let createNewNavigation = UINavigationController()
        let createNewCoordinator = CreateNewCoordinator(navigationController: createNewNavigation)
        createNewCoordinator.parentCoordinator = parentCoordinator
        parentCoordinator?.childCoordinators.append(createNewCoordinator)
        createNewCoordinator.start(viewModel: nil)
        navigationController.present(createNewNavigation, animated: true)
    }
    
    func startDiscoverCoordinator() -> UINavigationController {
        let discoverNavigation = UINavigationController()
        let discoverCoordinator = DiscoverCoordinator(navigationController: discoverNavigation)
        discoverCoordinator.parentCoordinator = parentCoordinator
        parentCoordinator?.childCoordinators.append(discoverCoordinator)
        discoverCoordinator.start()
        return discoverNavigation
    }
    
    func startMyRecipesCoordinator() -> UINavigationController {
        let myRecipesNavigation = UINavigationController()
        let myRecipesCoordinator = MyRecipesCoordinator(navigationController: myRecipesNavigation)
        myRecipesCoordinator.parentCoordinator = parentCoordinator
        parentCoordinator?.childCoordinators.append(myRecipesCoordinator)
        myRecipesCoordinator.start()
        return myRecipesNavigation
    }
    
}

