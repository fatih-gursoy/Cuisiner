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
    
    private var filteredRecipes: [Recipe]?
    private var selectedCategories = [Recipe.Category]()
    private var service: FirebaseServiceProtocol

    weak var delegate: RecipesViewModelDelegate?
      
    init(service: FirebaseServiceProtocol = FirebaseService.shared) {
        self.service = service
    }
    
    func recipeAtIndex(_ index:Int) -> RecipeViewModel? {
        guard let recipe = self.recipes?[index] else { return nil }
        return RecipeViewModel(recipe: recipe)
    }
    
    func fetchAllRecipes() {
        guard let blockedUsers = AuthManager.shared.user?.blockedUsers,
              let recipeBlackList = AuthManager.shared.user?.recipeBlackList
        else { return }
        
        service.fetchData(from: .recipes) { [weak self] (recipes: [Recipe]) in
            self?.filteredRecipes = recipes.filter { recipe in
                guard let id = recipe.id,
                      let ownerId = recipe.ownerId else { return false }
                return (!blockedUsers.contains(ownerId) && !recipeBlackList.contains(id))
            }
            self?.recipes = self?.filteredRecipes
            self?.delegate?.updateView()
        }
    }
    
    func filterRecipes(_ category: Recipe.Category) {
        if !selectedCategories.contains(category) {
            selectedCategories.append(category)
        } else {
            selectedCategories = selectedCategories.filter { $0 != category }
        }
        self.recipes = self.filteredRecipes?.filter({ selectedCategories.contains( $0.category) })
        delegate?.updateView()
    }
    
    func searchRecipes(_ searchText: String?) {
        guard let searchText = searchText?.lowercased() else {return}
        self.recipes = self.filteredRecipes?.filter {$0.name?.lowercased().hasPrefix(searchText) == true}
        delegate?.updateView()
    }
}
    
