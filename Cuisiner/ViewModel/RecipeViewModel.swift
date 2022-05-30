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
    
    var averageStar: String? {
        
        guard let ratingList = recipe.ratingList else { return "0" }
        let sum = ratingList.map { $0.score! }.reduce(0, +)
        let ratinglistAverage = Double(sum) / Double(ratingList.count)
        
        return String(format: "%.1f", ratinglistAverage)
    }
    
    var reviewCount: String? {
        guard let starList = recipe.ratingList else { return "0" }
        
        return String(describing: starList.count)
    }
    
    var myScore: Int {
        
        guard let myScore = (self.recipe.ratingList?.filter {
            $0.userId == AuthManager.shared.userId }.first)?.score
        else { return 0 }
        
        return myScore
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
        self.delegate?.updateView()
        
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
    
    func updateRating(_ rating: Rating) {
                
        if let index = self.recipe.ratingList?.firstIndex(where: { $0.userId == AuthManager.shared.userId })
        {
            self.recipe.ratingList?[index].score = rating.score
        } else {
            self.recipe.ratingList?.append(rating)
        }
        updateRecipe()
    }

}
