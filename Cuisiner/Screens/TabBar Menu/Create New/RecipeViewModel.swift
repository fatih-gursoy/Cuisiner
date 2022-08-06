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
           
    private var service: FirebaseServiceProtocol {return FirebaseService.shared}
    private var coredataManager = CoreDataManager()
    
    var recipe: Recipe
    var user: User?
    
    weak var delegate: RecipeViewModelDelegate? 
    
    init(recipe: Recipe) {
        self.recipe = recipe
    }
        
    // MARK: -Properties

    var recipeName: String? {
        return recipe.name
    }
    
    var recipeID: String {
        guard let recipeID = self.recipe.id else { return ""}
        return recipeID
    }
    
    var recipeImageUrl: String {
        guard let url = self.recipe.foodImageUrl else { return ""}
        return url
    }
    
    var category: String {
        return self.recipe.category.rawValue
    }
    
    var cookTime: String {
        guard let cookTime = self.recipe.cookTime else { return ""}
        return cookTime
    }
    
    var averageScore: String {
        var averageScore = 0.0
        guard let ratingList = recipe.ratingList else { return "0.0" }
        let sum = ratingList.map { $0.score! }.reduce(0, +)
        
        if sum > 0 { averageScore = Double(sum) / Double(ratingList.count) }
        return String(format: "%.1f", averageScore)
    }
    
    var reviewCount: String? {
        guard let starList = recipe.ratingList else { return "0" }
        return String(describing: starList.count)
    }
    
    var ingredients: [Ingredient]? {
        return recipe.ingredients
    }
    
    var instructions: [Instruction]? {
        return recipe.instructions
    }
    
    var isSaved: Bool {        
        return (coredataManager.fetchRecipe(recipeID) != nil)
    }
    
    var myScore: Int {
        guard let myScore = myRating?.score else { return 0 }
        return myScore
    }
    
    var myRating: Rating? {
        guard let index = self.ratingIndex else { return nil }
        return self.recipe.ratingList?[index]
    }
    
    private var ratingIndex: Int? {
        guard let index = self.recipe.ratingList?.firstIndex(where: {
            $0.userId == AuthManager.shared.userId })
        else { return nil }
        return index
    }
    
// MARK: -Firebase Functions
    
    func updateRecipe() {
        guard let recipeId = self.recipe.id else {return}
        service.update(from: .recipes, id: recipeId, self.recipe)
        self.delegate?.updateView()
    }
    
    func fetchUser() {
        guard let ownerId = recipe.ownerId else {return}
        service.fetchByField(from: .users, queryField: "userId",
                             queryParam: ownerId) { [weak self] (users: [User]) in
            
            guard let user = users.first else {return}
            self?.user = user
            
            DispatchQueue.main.async {
                self?.delegate?.updateView()
            }
        }
    }
    
    func updateRating(_ rating: Rating) {
        guard let score = rating.score else { return }
        
        if score > 0 {
            if self.myRating?.userId == rating.userId {
                guard let index = self.ratingIndex else { return }
                self.recipe.ratingList?[index].score = score
            } else {
                self.recipe.ratingList?.append(rating)
            }
        } else {
            guard let index = self.ratingIndex else { return }
            self.recipe.ratingList?.remove(at: index)
        }
        updateRecipe()
    }

// MARK: -CoreData Functions
    
    func addToSaveList() {
        coredataManager.addNewRecipe(self.recipeID)
    }
    
    func deleteFromSaveList() {
        coredataManager.deleteRecipe(with: self.recipeID)
    }
}
