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
       
    weak var delegate: MyRecipesViewModelDelegate?
    private var service: FirebaseServiceProtocol
    private var coredataManager = CoreDataManager.shared
    
    init(service: FirebaseServiceProtocol = FirebaseService.shared) {
        self.service = service
    }
    
    var recipes: [[Recipe]] = [[], []]
    var user: User? { return AuthManager.shared.user }
    var userId: String? { return AuthManager.shared.userId }
    
//MARK: - Private Functions
    
    private func fetchMyRecipes() {
        guard let userId = userId else {return}
        service.fetchByField(from: .recipes,
                             queryField: "ownerId",
                             queryParam: userId) { [weak self] (recipes: [Recipe]) in
            
            self?.recipes[0] = recipes
            self?.delegate?.updateView()
        }
    }
    
    private func fetchSavedRecipes() {
        
        let dispatchGroup = DispatchGroup()
        guard let blockedUsers = user?.blockedUsers else { return }
        
        let savedRecipes = coredataManager.savedRecipes.filter { recipe in
            guard let ownerId = recipe.ownerID else {return true}
            return !blockedUsers.contains(ownerId)
        }
        
        var mysavedRecipes = [Recipe]()
        
        for recipe in savedRecipes {
            dispatchGroup.enter()
            guard let recipeID = recipe.recipeID else { return }
            
            service.getDocumentByField(from: .recipes,
                                 queryField: "id",
                                 queryParam: recipeID) { (recipes: [Recipe]) in
                _ = recipes.compactMap { mysavedRecipes.append($0) }
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) {
            self.recipes[1] = mysavedRecipes
            self.delegate?.updateView()
        }
    }
    
    
//MARK: - Functions
    
    func load() {
        self.fetchMyRecipes()
        self.fetchSavedRecipes()
    }

    func recipeAtIndex(selectedTable: Int, index:Int) -> RecipeViewModel? { 
        let recipe = self.recipes[selectedTable][index]
        return RecipeViewModel(recipe: recipe)
    }
    
    func deleteRecipe(viewModel: RecipeViewModel) {
        
        let group = DispatchGroup()
        
        group.enter()
        service.delete(from: .recipes, with: viewModel.recipeID) { success in
            if success { group.leave()}
        }
        
        group.enter()
        StorageService.shared.deleteImage(imageUrl: viewModel.recipeImageUrl) { success in
            if success { group.leave()}
        }
        group.notify(queue: .main) { [weak self] in
            self?.delegate?.updateView()
        }
    }
    
    func deleteFromSaveList(viewModel: RecipeViewModel) {
        coredataManager.deleteRecipe(with: viewModel.recipeID)
        fetchSavedRecipes()
    }
}
