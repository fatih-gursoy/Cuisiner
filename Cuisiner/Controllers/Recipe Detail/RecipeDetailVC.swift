//
//  RecipeDetailVC.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 25.04.2022.
//

import UIKit

class RecipeDetailVC: UIViewController {
   
    @IBOutlet private weak var recipeImage: CustomImageView!
    @IBOutlet private weak var userImage: CustomImageView!
    
    @IBOutlet private weak var recipeName: UILabel!
    @IBOutlet private weak var userName: UILabel!
    @IBOutlet private weak var ingredientTable: UITableView!
    @IBOutlet private weak var starButton: UIButton!
    @IBOutlet private weak var reviewCountLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var recipeViewModel: RecipeViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        configureUI()
        configureNavBar()

    }
    
    func configureTableView() {
        
        ingredientTable.delegate = self
        ingredientTable.dataSource = self
        
        ingredientTable.register(UINib(nibName: "IngredientTableCell", bundle: nil), forCellReuseIdentifier: IngredientTableCell.identifier)
        
    }
    
    func configureUI() {
        
        recipeViewModel?.delegate = self
        recipeName.text = recipeViewModel?.recipeName
        recipeImage.setImage(url: recipeViewModel?.recipe.foodImageUrl)
        starButton.setTitle(recipeViewModel?.star, for: .normal)
                
    }
    	
    func configureNavBar() {
        
        let barButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeTapped))
        
        self.navigationItem.rightBarButtonItem = barButton
        
    }
    
    @objc func closeTapped() {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func startClicked(_ sender: Any) {
        
        guard let startCookVC = self.storyboard?.instantiateViewController(withIdentifier: "StartCookVC") as? StartCookVC else {return}
        
        startCookVC.recipeViewModel = self.recipeViewModel
        self.navigationController?.pushViewController(startCookVC, animated: true)
        
    }
    

}


extension RecipeDetailVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return recipeViewModel?.ingredients?.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: IngredientTableCell.identifier, for: indexPath) as? IngredientTableCell else { fatalError("Could not load") }
        
        cell.configure(ingredient: recipeViewModel?.ingredients?[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerTitle: UILabel = {
            let title = UILabel()
            title.text = "Ingredients"
            title.font = UIFont(name: "Gill Sans SemiBold", size: 20.0)
            return title
        }()
        return headerTitle
        
    }
    
    
    
    
    
}

extension RecipeDetailVC: RecipeViewModelDelegate {
    
    func updateView() {
        
        userName.text = recipeViewModel?.user?.userName
        userImage.setImage(url: recipeViewModel?.user?.userImageUrl)

    }

}
