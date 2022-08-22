//
//  CreateNewCoordinator.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 22.08.2022.
//

import Foundation
import UIKit

class CreateNewCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    weak var parentCoordinator: AppCoordinator?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start(viewModel: RecipeViewModel?) {
        let createNewVC = CreateNewVC.instantiateFromStoryboard()
        createNewVC.coordinator = self
        createNewVC.recipeViewModel = viewModel
        let closeButton = UIBarButtonItem(image: #imageLiteral(resourceName: "xmark"), style: .plain, target: self, action: #selector(close))
        createNewVC.navigationItem.rightBarButtonItem = closeButton
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.pushViewController(createNewVC, animated: false)
    }
    
    @objc func close() {
        parentCoordinator?.childDidFinish(self)
        navigationController.dismiss(animated: true)
    }
    
    func gotoPrepareVC(viewModel: RecipeViewModel?, delegate: ImagePassDelegate?) {
        let prepareVC = PrepareVC.instantiateFromStoryboard()
        prepareVC.coordinator = self
        prepareVC.recipeViewModel = viewModel
        prepareVC.delegate = delegate
        navigationController.pushViewController(prepareVC, animated: true)
    }
    
}
