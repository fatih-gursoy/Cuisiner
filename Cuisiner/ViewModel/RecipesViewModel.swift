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
    
    private var service: FirebaseServiceProtocol
      
    init(service: FirebaseServiceProtocol = FirebaseService.shared) {
        self.service = service
    }
    
    func recipeAtIndex(_ index:Int) -> RecipeViewModel? {
        
        guard let recipe = self.recipes?[index] else { return nil }
            
        return RecipeViewModel(recipe: recipe)
        
    }
    
    
    func fetchAllRecipes() {
                
        service.fetchData(from: .recipes) { [weak self] (recipes: [Recipe]) in
            
            self?.recipes = recipes
            DispatchQueue.main.async {
               self?.delegate?.updateView()
           }
        }
    }
        
    func fetchMyRecipes() {
     
        guard let userId = CurrentUser.shared.userId else {return }
     
        service.fetchByOwner(from: .recipes, ownerId: userId) { [weak self] (recipes: [Recipe]) in
            self?.recipes = recipes
            DispatchQueue.main.async {
               self?.delegate?.updateView()
           }
        }
    }

    
}
    
