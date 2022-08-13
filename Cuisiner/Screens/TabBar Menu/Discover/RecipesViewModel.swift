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
    
    private var allRecipes: [Recipe]?
    private var selectedCategories = [Recipe.Category]()
    
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
        guard let blockedUsers = AuthManager.shared.user?.blockedUsers else { return }
        
        service.fetchData(from: .recipes) { [weak self] (recipes: [Recipe]) in
            let recipes = recipes.filter( { !(blockedUsers.contains($0.ownerId!)) })
            self?.recipes = recipes
            self?.allRecipes = recipes
            self?.delegate?.updateView()
        }
    }
    
    func filterRecipes(_ category: Recipe.Category) {
        if !selectedCategories.contains(category) {
            selectedCategories.append(category)
        } else {
            selectedCategories = selectedCategories.filter { $0 != category }
        }
        self.recipes = self.allRecipes?.filter({ selectedCategories.contains( $0.category) })
        delegate?.updateView()
    }
    
    func searchRecipes(_ searchText: String?) {
        guard let searchText = searchText?.lowercased() else {return}
        switch searchText {
        case "":
            self.recipes = allRecipes
        default:
            self.recipes = self.allRecipes?.filter { $0.name?.lowercased().hasPrefix(searchText) == true }
        }
        delegate?.updateView()
    }
}
    
