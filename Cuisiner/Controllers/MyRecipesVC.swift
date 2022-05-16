//
//  MyRecipesVC.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 10.03.2022.
//

import UIKit

class MyRecipesVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private var recipesViewModel = RecipesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "MyRecipeTableCell", bundle: nil), forCellReuseIdentifier: MyRecipeTableCell.identifier)
        
        tableView.delegate = self
        tableView.dataSource = self

        configureNavBar()
        fetchData()
    }

    @objc func signOut() {
        
        AuthManager.shared.signOut()
        
        self.dismiss(animated: true)
        self.tabBarController?.hidesBottomBarWhenPushed = true
        
        guard let welcomeVC = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeVC") as? WelcomeVC else { fatalError("Could't load") }
        
        welcomeVC.modalPresentationStyle = .fullScreen
        self.present(welcomeVC, animated: true)
                
    }

    
    func configureNavBar() {
        
        let logoutUser = UIAction(title: "Log out", image: UIImage(systemName: "power.circle.fill")) { _ in
            self.signOut()
        }
        
        let myProfile = UIAction(title: "Profile Settings", image: UIImage(systemName: "person.circle.fill")) { _ in
            
        }
        
        let menu = UIMenu(options: .displayInline,
                          children: [myProfile, logoutUser])
        
        let barButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), menu: menu)
        self.navigationItem.rightBarButtonItem = barButton
        
        
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
