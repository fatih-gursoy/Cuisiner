//
//  RecipesViewModel.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 29.03.2022.
//

import Foundation

protocol RecipesViewModelDelegate: AnyObject {
    func updateView()
}

class RecipesViewModel {
       
    var recipes: [Recipe]?
    
    weak var delegate: RecipesViewModelDelegate?
    
    private var service: FirebaseServiceProtocol {
        return FirebaseService.shared
    }
      
    init() {}
    
    func getRecipes() {
                
        service.fetchRecipes(completion: { [weak self] recipes in
            if let recipes = recipes {
                self?.recipes = recipes
                
                DispatchQueue.main.async {
                    self?.delegate?.updateView()
                }
            }
        })
        
    }

    
}
    
