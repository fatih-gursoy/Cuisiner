//
//  MyRecipesVC.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 10.03.2022.
//

import UIKit
import MessageUI

class MyRecipesVC: UIViewController, Storyboardable {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    
    private var myRecipesViewModel = MyRecipesViewModel()
    var notificationCenter = NotificationCenter.default
    weak var coordinator: MyRecipesCoordinator?
    
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
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyRecipeTableCell.identifier) as? MyRecipeTableCell else { fatalError("Could not load") }
        
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
            guard let recipeViewModel = myRecipesViewModel.recipeAtIndex(selectedTable: selectedTable,
                                                                         index: indexPath.row) else {return}
            coordinator?.gotoUpdateRecipe(viewModel: recipeViewModel)
            
        case 1:

            guard let recipeViewModel = myRecipesViewModel.recipeAtIndex(selectedTable: selectedTable,
                                                                         index: indexPath.row) else {return}
            coordinator?.gotoRecipeDetailVC(viewModel: recipeViewModel)
            
        default:
            break
        }
    }
    
}

//MARK: -Navbar Menu Configuration

extension MyRecipesVC {
    
    func configureNavBar() {
                       
        let myProfile = UIAction(title: "Profile Settings", image: UIImage(systemName: "person.circle.fill")) { [weak self] _ in
            self?.routeToProfileVC()
        }

        let contact = UIAction(title: "Contact Us", image: UIImage(systemName: "info.circle.fill")) { [weak self] _ in
            self?.contactUs()
        }
        
        let logoutUser = UIAction(title: "Log out", image: UIImage(systemName: "power.circle.fill")) { [weak self] _ in
            self?.dismiss(animated: true)
            self?.signOut()
        }
        
        let menu = UIMenu(options: .displayInline, children: [myProfile, contact, logoutUser])
        let menuButton = UIBarButtonItem(image: UIImage(systemName: "gearshape.fill"), menu: menu)
        self.navigationItem.rightBarButtonItem = menuButton
    }
    
    func routeToProfileVC() {
        
        guard let user = myRecipesViewModel.user else {return}
        let userViewModel = UserViewModel(user: user)
        
        let navController = UINavigationController(rootViewController: ProfileVCBuilder.build(viewModel: userViewModel))
        
        navController.modalPresentationCapturesStatusBarAppearance = true
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated: true)
    }
    
    func contactUs() {
        
        if MFMailComposeViewController.canSendMail() {
            let mailVC = MFMailComposeViewController()
            mailVC.mailComposeDelegate = self
            mailVC.setToRecipients(["fatihgursoy85@gmail.com"])
            present(mailVC, animated: true)
        } else {
            presentAlert(title: "Mail Error!", message: "Please set your email account in your phone", completion: nil)
        }
    }
    
    func signOut() {
        AuthManager.shared.signOut()
        coordinator?.logout()
    }
}

extension MyRecipesVC: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
