//
//  RecipeViewModel.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 24.03.2022.
//

import Foundation

class RecipeViewModel {
           
    private var service: FirebaseServiceProtocol {
        return FirebaseService.shared
    }
    
    var recipe: Recipe
    
    init(recipe: Recipe) {
        self.recipe = recipe
    }
    
    var recipeName: String? {
        return recipe.name
    }
    
    var star: String? {
        guard let star = recipe.favoriteStar else { return "0" }
        return String(describing: star)
    }
    
    var ownerName: String? {
        
        return recipe.ownerId
    }
    
    

// MARK: Functions
    
    func createNew() {        
        service.add(with: self.recipe)
    }
    
    func updateRecipe() {
        service.update(recipe: self.recipe)
    }
    
    func delete() {
        if let id = self.recipe.id {
            service.delete(with: id)
        }
    }

    
}
