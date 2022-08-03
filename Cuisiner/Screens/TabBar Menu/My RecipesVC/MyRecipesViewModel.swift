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
    var user: User?
    
    weak var delegate: MyRecipesViewModelDelegate?
    
    private var service: FirebaseServiceProtocol
    private var coredataManager = CoreDataManager()
          
    init(service: FirebaseServiceProtocol = FirebaseService.shared) {
        self.service = service
    }
    
    var userId: String? {
        return AuthManager.shared.userId
    }
    
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
        let recipeIDs = coredataManager.savedRecipes.map { $0.recipeID }
        
        var mysavedRecipes = [Recipe]()
        
        for recipeID in recipeIDs {
            dispatchGroup.enter()
            guard let recipeID = recipeID else { return }
            
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
        self.fetchUser()
    }
    
    func fetchUser() {
        guard let userId = userId else {return}

        service.fetchByField(from: .users, queryField: "userId",
                             queryParam: userId) { [weak self] (users: [User]) in
            
            guard let user = users.first else {return}
            self?.user = user
        }
    }
    
    func recipeAtIndex(selectedTable: Int, index:Int) -> RecipeViewModel? { 
        let recipe = self.recipes[selectedTable][index]
        return RecipeViewModel(recipe: recipe)
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
