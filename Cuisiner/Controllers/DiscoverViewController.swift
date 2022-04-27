//
//  HomeViewController.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 9.03.2022.
//

import UIKit

class DiscoverViewController: UIViewController {

    @IBOutlet private weak var categoryCollectionView: UICollectionView!
    @IBOutlet private weak var recipeCollectionView: UICollectionView!
    @IBOutlet private weak var searchBar: UISearchBar!
    
    private var recipesViewModel = RecipesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        fetchRecipes()
    }
    
    func configureCollectionView() {
        
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        
        recipeCollectionView.delegate = self
        recipeCollectionView.dataSource = self
        
        categoryCollectionView.register(UINib(nibName: "CategoryCell", bundle: nil), forCellWithReuseIdentifier: CategoryCell.identifier)

        recipeCollectionView.register(UINib(nibName: "RecipeCell", bundle: nil), forCellWithReuseIdentifier: RecipeCell.identifier)
        
    }
    
    func fetchRecipes() {
        
        recipesViewModel.delegate = self
        recipesViewModel.fetchAllRecipes()
        
    }
   
}

extension DiscoverViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView {
            
        case categoryCollectionView:
            
            return Recipe.Category.allCases.count
            
        case recipeCollectionView:
            
            guard let count = recipesViewModel.recipes?.count else { return 0 }
            return  count
            
        default:
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
            
        case categoryCollectionView:
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.identifier, for: indexPath) as? CategoryCell else { fatalError("Could not load") }
                               
            let title = Recipe.Category.allCases[indexPath.row].rawValue
            
            cell.configureCell(title: title)
            
            return cell
            
        case recipeCollectionView:
                        
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeCell.identifier, for: indexPath) as? RecipeCell else { fatalError("Could not load") }
            
            cell.configure(viewModel: recipesViewModel.recipeAtIndex(indexPath.row))
                    
            return cell
            
        default:
            return UICollectionViewCell()
        }
            
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch collectionView {
            
        case categoryCollectionView:
            
            let item = Recipe.Category.allCases[indexPath.row].rawValue

            let itemWidth = (item.size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18)]).width) + 30
            
            let itemHeight = collectionView.bounds.height * 0.70
                        
            return CGSize(width: itemWidth, height: itemHeight)
            
        case recipeCollectionView:
            
            let itemWidth = collectionView.bounds.width
            let itemHeight = collectionView.bounds.height * 0.50
            
            return CGSize(width: itemWidth, height: itemHeight)

        default:
            return CGSize()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == categoryCollectionView {
            
            guard let cell = collectionView.cellForItem(at: indexPath) as? CategoryCell else { fatalError("Could not load") }
                    
            cell.didSelect()
            
        }
            
        
    }
    
}

extension DiscoverViewController: RecipesViewModelDelegate {
    
    func updateView() {
        self.recipeCollectionView.reloadData()
    }
    
}
