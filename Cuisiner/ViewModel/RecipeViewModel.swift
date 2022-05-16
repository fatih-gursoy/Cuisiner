//
//  RecipeViewModel.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 24.03.2022.
//

import Foundation

protocol RecipeViewModelDelegate: AnyObject {
    func updateView()
}

class RecipeViewModel {
           
    private var service: FirebaseServiceProtocol {
        return FirebaseService.shared
    }
    
    var recipe: Recipe
    var user: User?
    
    weak var delegate: RecipeViewModelDelegate? 
    
    init(recipe: Recipe) {
        self.recipe = recipe
        self.fetchUser()
    }
    
    var recipeName: String? {
        return recipe.name
    }
    
    var star: String? {
        guard let star = recipe.favoriteStar else { return "0" }
        return String(describing: star)
    }
    
    var ingredients: [Ingredient]? {
        return recipe.ingredients
    }
    
    var instructions: [Instruction]? {
        return recipe.instructions
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
    
    func fetchUser() {
        
        service.fetchByField(from: .users, queryField: "userId",
                             queryParam: recipe.ownerId!) { [weak self] (users: [User]) in
            
            guard let user = users.first else {return}
            self?.user = user
            
            DispatchQueue.main.async {
                self?.delegate?.updateView()
            }
        }
    }

}
