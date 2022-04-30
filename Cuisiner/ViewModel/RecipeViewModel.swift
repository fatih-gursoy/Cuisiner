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
        service.addNew(to: .recipes, self.recipe)
    }
    
    func updateRecipe() {
        guard let recipeId = self.recipe.id else {return}
        service.update(from: .recipes, id: recipeId, self.recipe)
    }
    
    func delete() {
        guard let recipeId = self.recipe.id else {return}
        service.delete(from: .recipes, with: recipeId)
    }

    
}
