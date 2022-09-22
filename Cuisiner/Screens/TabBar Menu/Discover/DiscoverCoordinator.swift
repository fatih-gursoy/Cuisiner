//
//  DiscoverCoordinator.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 22.08.2022.
//

import Foundation
import UIKit

class DiscoverCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    weak var parentCoordinator: AppCoordinator?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let discoverVC = DiscoverVC.instantiateFromStoryboard()
        discoverVC.coordinator = self
        navigationController.pushViewController(discoverVC, animated: false)
        navigationController.setNavigationBarHidden(true, animated: true)
    }
    
    func gotoRecipeDetailVC(viewModel: RecipeViewModel) {
        let recipeDetailNavigation = UINavigationController()
        let recipeDetailCoordinator = RecipeDetailCoordinator(navigationController: recipeDetailNavigation)
        recipeDetailCoordinator.parentCoordinator = parentCoordinator
        parentCoordinator?.childCoordinators.append(recipeDetailCoordinator)
        recipeDetailCoordinator.start(viewModel: viewModel)
        navigationController.present(recipeDetailNavigation, animated: true)
    }
}
