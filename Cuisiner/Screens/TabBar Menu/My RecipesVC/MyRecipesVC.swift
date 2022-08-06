//
//  MyRecipesVC.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 10.03.2022.
//

import UIKit

class MyRecipesVC: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    
    private var myRecipesViewModel = MyRecipesViewModel()
    var notificationCenter = NotificationCenter.default
    
    private var selectedTable: Int = 0 {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myRecipesViewModel.delegate = self
        configureTableView()
        configureNavBar()
        myRecipesViewModel.load()
        notificationCenter.addObserver(self, selector: #selector(refreshSavedList(_:)), name: NSNotification.Name(rawValue: "RefreshSavedList"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func refreshSavedList(_ notification: Notification) {
        myRecipesViewModel.load()
    }
    
    func configureTableView() {
        
        tableView.register(UINib(nibName: "MyRecipeTableCell", bundle: nil),
                           forCellReuseIdentifier: MyRecipeTableCell.identifier)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        self.selectedTable = sender.selectedSegmentIndex
    }
}

extension MyRecipesVC: MyRecipesViewModelDelegate {
    
    func updateView() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}


//MARK: -Tableview Delegates

extension MyRecipesVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myRecipesViewModel.recipes[selectedTable].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MyRecipeTableCell.identifier) as! MyRecipeTableCell
        
        cell.configure(viewModel: myRecipesViewModel.recipeAtIndex(selectedTable: selectedTable,
                                                                   index: indexPath.row))
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            guard let recipeVM = myRecipesViewModel.recipeAtIndex(selectedTable: selectedTable,
                                                                  index: indexPath.row) else {return}
            
            switch selectedTable {
            case 0:
                myRecipesViewModel.deleteRecipe(viewModel: recipeVM)
            case 1:
                myRecipesViewModel.deleteFromSaveList(viewModel: recipeVM)
            default:
                break
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch selectedTable {
        case 0:
            guard let createNewNav = self.storyboard?.instantiateViewController(withIdentifier:         "CreateNewNav") as? UINavigationController,
                  let createNewVC = createNewNav.viewControllers.first as? CreateNewVC
                    
            else {fatalError("Could not Load")}
            
            createNewNav.modalPresentationStyle = .fullScreen
            createNewNav.modalPresentationCapturesStatusBarAppearance = true
            createNewVC.recipeViewModel = myRecipesViewModel.recipeAtIndex(selectedTable: selectedTable, index: indexPath.row)
            self.present(createNewNav, animated: true)
            
        case 1:
            guard let recipeDetailNav = self.storyboard?.instantiateViewController(withIdentifier: "RecipeDetailNav") as? UINavigationController,
                  let recipeDetailVC = recipeDetailNav.viewControllers.first as? RecipeDetailVC
                    
            else {fatalError("Could not Load")}
            
            recipeDetailNav.modalPresentationStyle = .fullScreen
            recipeDetailNav.modalPresentationCapturesStatusBarAppearance = true
            recipeDetailVC.recipeViewModel = myRecipesViewModel.recipeAtIndex(selectedTable: selectedTable, index: indexPath.row)
            self.present(recipeDetailNav, animated: true)
                    
        default:
            break
        }
    }
    
}

//MARK: -Navbar Menu Configuration

extension MyRecipesVC {
    
    func configureNavBar() {
                       
        let myProfile = UIAction(title: "Profile Settings", image: UIImage(systemName: "person.circle.fill")) { _ in
            self.routeToProfileVC()
        }

        let help = UIAction(title: "Help", image: UIImage(systemName: "info.circle.fill")) { _ in
            //
        }
        
        let logoutUser = UIAction(title: "Log out", image: UIImage(systemName: "power.circle.fill")) { _ in
            self.signOut()
        }
        
        let menu = UIMenu(options: .displayInline, children: [myProfile, help, logoutUser])
        let barButton = UIBarButtonItem(image: UIImage(systemName: "gearshape.fill"), menu: menu)
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    func routeToProfileVC() {
        
        guard let user = myRecipesViewModel.user else {return}
        let userViewModel = UserViewModel(user: user)
        
        let navController = UINavigationController(rootViewController: ProfileVCBuilder.build(viewModel: userViewModel))
        
        navController.modalPresentationCapturesStatusBarAppearance = true
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated: true)
    }
    
    func signOut() {
        
        AuthManager.shared.signOut()
        
        self.dismiss(animated: true)
        self.tabBarController?.hidesBottomBarWhenPushed = true
        
        guard let welcomeVC = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeVC") as? WelcomeVC else { fatalError("Could't load") }
        
        welcomeVC.modalPresentationStyle = .fullScreen
        self.present(welcomeVC, animated: true)
    }
}
