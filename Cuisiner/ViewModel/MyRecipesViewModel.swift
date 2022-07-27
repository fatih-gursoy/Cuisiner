//
//  MyRecipesViewModel.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 28.06.2022.
//

import Foundation

protocol MyRecipesViewModelDelegate: AnyObject {
    func updateView()
}

class MyRecipesViewModel {
       
    var recipes: [[Recipe]] = [[], []]
    
    weak var delegate: MyRecipesViewModelDelegate?
    
    private var service: FirebaseServiceProtocol
    private var coredataManager = CoreDataManager()
          
    init(service: FirebaseServiceProtocol = FirebaseService.shared) {
        self.service = service
    }
    
    func recipeAtIndex(selectedTable: Int, index:Int) -> RecipeViewModel? { 
        let recipe = self.recipes[selectedTable][index]
        return RecipeViewModel(recipe: recipe)
    }
        
    func fetchMyRecipes() {
     
        guard let userId = AuthManager.shared.userId else {return}
     
        service.fetchByField(from: .recipes,
                             queryField: "ownerId",
                             queryParam: userId) { [weak self] (recipes: [Recipe]) in
            
            self?.recipes[0] = recipes
            
            DispatchQueue.main.async {
               self?.delegate?.updateView()
            }
        }
    }
    
    func fetchSavedRecipes() {
     
        let dispatchGroup = DispatchGroup()
        
        let recipeIDs = coredataManager.savedRecipes.map { $0.recipeID }
        var savedRecipes = [Recipe]()
        
        for recipeID in recipeIDs {
                
            dispatchGroup.enter()
            guard let recipeID = recipeID else { return }
            
            service.fetchByField(from: .recipes,
                                 queryField: "id",
                                 queryParam: recipeID) { (recipes: [Recipe]) in
                
                _ = recipes.map { savedRecipes.append($0) }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.recipes[1] = savedRecipes
            self.delegate?.updateView()
        }

    }
    
    func deleteRecipe(id: String) {
        
        service.delete(from: .recipes, with: id)
        delegate?.updateView()
        
    }
    
    func deleteFromSaveList(id: String) {
        
        coredataManager.deleteRecipe(with: id)
        fetchSavedRecipes()
    }
    
}
