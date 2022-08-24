//
//  HomeViewController.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 9.03.2022.
//

import UIKit

class DiscoverVC: UIViewController, Storyboardable {

    @IBOutlet private weak var categoryCollectionView: UICollectionView!
    @IBOutlet private weak var recipeCollectionView: UICollectionView!
    @IBOutlet private weak var searchBar: UISearchBar!
    
    private var recipesViewModel = RecipesViewModel()
    weak var coordinator: DiscoverCoordinator?
    var notificationCenter = NotificationCenter.default

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        configureCollectionView()
        fetchRecipes()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func configureCollectionView() {
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        recipeCollectionView.delegate = self
        recipeCollectionView.dataSource = self
        categoryCollectionView.register(UINib(nibName: "CategoryCell", bundle: nil), forCellWithReuseIdentifier: CategoryCell.identifier)
        recipeCollectionView.register(UINib(nibName: "RecipeCell", bundle: nil), forCellWithReuseIdentifier: RecipeCell.identifier)
        categoryCollectionView.allowsMultipleSelection = true
    }
    
    func fetchRecipes() {
        recipesViewModel.delegate = self
        AuthManager.shared.fetchUser { [weak self] success in
            if success { self?.recipesViewModel.fetchAllRecipes() }
        }
    }
   
}

extension DiscoverVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView {
            
        case categoryCollectionView:
            return Recipe.Category.allCases.count
        case recipeCollectionView:
            guard let count = recipesViewModel.recipes?.count else { return 0 }
            return count
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
            cell.delegate = self
            cell.tag = indexPath.row
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch collectionView {
            
        case categoryCollectionView:
            
            let item = Recipe.Category.allCases[indexPath.row].rawValue
            let itemWidth = (item.size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18)]).width) + 40
            let itemHeight = collectionView.bounds.height * 0.80
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
            let category = Recipe.Category.allCases[indexPath.row]
            recipesViewModel.filterRecipes(category)
        }
        
        if collectionView == recipeCollectionView {
            guard let recipeViewModel = recipesViewModel.recipeAtIndex(indexPath.row) else {return}
            coordinator?.gotoRecipeDetailVC(viewModel: recipeViewModel)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        if collectionView == categoryCollectionView {
            
            guard let cell = collectionView.cellForItem(at: indexPath) as? CategoryCell else { fatalError("Could not load") }
            cell.didDeSelect()
            
            let category = Recipe.Category.allCases[indexPath.row]
            recipesViewModel.filterRecipes(category)
            
            if collectionView.indexPathsForSelectedItems?.count == 0 {
                recipesViewModel.fetchAllRecipes()
            }
        }
    }
    
}

extension DiscoverVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        recipesViewModel.searchRecipes(searchText)
    }
}

extension DiscoverVC: RecipesViewModelDelegate {
    
    func updateView() {
        DispatchQueue.main.async { [weak self] in
            self?.recipeCollectionView.reloadData()
            self?.notificationCenter.post(name: NSNotification.Name(rawValue: "RefreshSavedList"), object: nil)
        }
    }
}

//MARK: - ActionSheet Delegates

extension DiscoverVC: CellActionButtonDelegate {
    
    func actionButtonTapped(cell: UICollectionViewCell) {
        let actionSheet = CustomActionSheet()
        actionSheet.delegate = self
        actionSheet.actionIndex = cell.tag
        present(actionSheet, animated: true)
    }
}

extension DiscoverVC: ActionSheetDelegate {

    func handler(index: Int, action: UIAlertAction) {
        
        guard let recipeViewModel = self.recipesViewModel.recipeAtIndex(index),
              let currentUser = AuthManager.shared.user else {return}
        
        switch action.title {
        
        case actionType.report.title:
            let alertVC = CustomAlertVC(message: AlertMessages.report,
                                        image: UIImage(systemName: "hand.thumbsdown.fill"))
            present(alertVC, animated: true)
            
            alertVC.doneCompletion = {
                recipeViewModel.addtoReportedRecipes(currentUserId: currentUser.userId!)
            }
        case actionType.hide.title:
            recipeViewModel.addtoBlackList()
            
        case actionType.block.title:
            let userVM = UserViewModel(user: currentUser)
            userVM.blockUserHandler(userId: recipeViewModel.ownerID)
        
        default:
            break
        }
    }
}

