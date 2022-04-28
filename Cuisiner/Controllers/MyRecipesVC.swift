//
//  MyRecipesVC.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 10.03.2022.
//

import UIKit

class MyRecipesVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var userViewModel = UserViewModel()
    var recipesViewModel = RecipesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "MyRecipeTableCell", bundle: nil), forCellReuseIdentifier: MyRecipeTableCell.identifier)
        
        tableView.delegate = self
        tableView.dataSource = self

        let barButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(signOut))
        
        self.navigationItem.rightBarButtonItem = barButton
        
        fetchData()
    }

    @objc func signOut() {
        
        userViewModel.signOut()
        performSegue(withIdentifier: "toFirstVC", sender: nil)
    }

    
    func fetchData() {
        
        recipesViewModel.delegate = self
        recipesViewModel.fetchMyRecipes()
        
    }

}

extension MyRecipesVC: RecipesViewModelDelegate {
    
    func updateView() {
        tableView.reloadData()
    }
}


extension MyRecipesVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        recipesViewModel.recipes?.count ?? 0
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MyRecipeTableCell.identifier) as! MyRecipeTableCell
        
        cell.configure(viewModel: recipesViewModel.recipeAtIndex(indexPath.row))
      
        return cell
        
    }

}
