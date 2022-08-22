//
//  MyRecipesCoordinator.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 22.08.2022.
//

import Foundation
import UIKit

class MyRecipesCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    weak var parentCoordinator: AppCoordinator?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let myRecipesVC = MyRecipesVC.instantiateFromStoryboard()
        myRecipesVC.coordinator = self
        navigationController.pushViewController(myRecipesVC, animated: false)
    }
    
    func gotoUpdateRecipe(viewModel: RecipeViewModel) {
        let createNewNavigation = UINavigationController()
        let createNewCoordinator = CreateNewCoordinator(navigationController: createNewNavigation)
        createNewCoordinator.parentCoordinator = parentCoordinator
        parentCoordinator?.childCoordinators.append(createNewCoordinator)
        createNewCoordinator.start(viewModel: viewModel)
        navigationController.present(createNewNavigation, animated: true)
    }
    
    func gotoRecipeDetailVC(viewModel: RecipeViewModel) {
        let recipeDetailNavigation = UINavigationController()
        let recipeDetailCoordinator = RecipeDetailCoordinator(navigationController: recipeDetailNavigation)
        recipeDetailCoordinator.parentCoordinator = parentCoordinator
        parentCoordinator?.childCoordinators.append(recipeDetailCoordinator)
        recipeDetailCoordinator.start(viewModel: viewModel)
        navigationController.present(recipeDetailNavigation, animated: true)
    }
    
    func gotoProfile(viewModel: UserViewModel) {
        let profileNavigation = UINavigationController()
        let profileCoordinator = ProfileCoordinator(navigationController: profileNavigation)
        profileCoordinator.parentCoordinator = parentCoordinator
        parentCoordinator?.childCoordinators.append(profileCoordinator)
        profileCoordinator.start(viewModel: viewModel)
        navigationController.present(profileNavigation, animated: true)
    }
    
    func logout() {
        parentCoordinator?.childCoordinators.removeAll()
        parentCoordinator?.gotoAuth()
    }
    
}
