//
//  RecipeDetailCoordinator.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 22.08.2022.
//

import Foundation
import UIKit

class RecipeDetailCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    weak var parentCoordinator: AppCoordinator?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start(viewModel: RecipeViewModel) {
        let recipeDetailVC = RecipeDetailVC.instantiateFromStoryboard()
        recipeDetailVC.coordinator = self
        recipeDetailVC.recipeViewModel = viewModel
        let closeButton = UIBarButtonItem(image: #imageLiteral(resourceName: "xmark"), style: .plain, target: self, action: #selector(close))
        recipeDetailVC.navigationItem.rightBarButtonItem = closeButton
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.pushViewController(recipeDetailVC, animated: false)
    }
    
    @objc func close() {
        parentCoordinator?.childDidFinish(self)
        navigationController.dismiss(animated: true)
    }
    
    func gotoStartCookVC(viewModel: RecipeViewModel?) {
        let startCookVC = StartCookVC.instantiateFromStoryboard()
        startCookVC.coordinator = self
        startCookVC.recipeViewModel = viewModel
        navigationController.pushViewController(startCookVC, animated: true)
    }
}
