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
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var bookmarkButton: UIButton!
    @IBOutlet private weak var userStackView: UIStackView!
    
    var recipeViewModel: RecipeViewModel!
    var notificationCenter = NotificationCenter.default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recipeViewModel.delegate = self
        configureTableView()
        configureUI()
        configureNavBar()
        addTapGesture()
    }
    
    func configureTableView() {
        ingredientTable.delegate = self
        ingredientTable.dataSource = self
        ingredientTable.register(UINib(nibName: "IngredientTableCell", bundle: nil),
                                 forCellReuseIdentifier: IngredientTableCell.identifier)
    }
    
    func configureUI() {
        recipeViewModel.fetchUser()
        recipeName.text = recipeViewModel?.recipeName
        recipeImage.setImage(url: recipeViewModel.recipe.foodImageUrl)
        starButton.setTitle(recipeViewModel?.averageScore, for: .normal)
        
        if recipeViewModel.recipe.ownerId == AuthManager.shared.userId {
            bookmarkButton.isHidden = true
        } else {
            bookmarkButton.isSelected = recipeViewModel.isSaved
        }
    }
    
    func addTapGesture() {
        userStackView.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(toProfileVC))
        userStackView.addGestureRecognizer(gesture)
    }
    
    @objc func toProfileVC() {
        guard let user = recipeViewModel.user else {return}
        let userViewModel = UserViewModel(user: user)
        
        let navController = UINavigationController(rootViewController: ProfileVCBuilder.build(viewModel: userViewModel))
        navController.modalPresentationCapturesStatusBarAppearance = true
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated: true)
    }
    
    func configureNavBar() {
        
        let buttonImage =  #imageLiteral(resourceName: "XMark")
        let barButton = UIBarButtonItem(image: buttonImage, style: .plain,
                                        target: self, action: #selector(closeTapped))
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
    
    @IBAction func starButtonClicked(_ sender: Any) {
        
        guard let myScore = recipeViewModel?.myScore else {return}
        let popupVC = CustomPopupVC(type:.star(score: myScore))
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.modalTransitionStyle = .crossDissolve
        
        popupVC.doneTappedCompletion = {
            let score = popupVC.starView?.score
            let myRating = Rating(userId: AuthManager.shared.userId, score: score)
            self.recipeViewModel?.updateRating(myRating)
        }
        present(popupVC, animated: true)
    }
    
    @IBAction func bookmarkTapped(_ sender: Any) {
        
        bookmarkButton.isSelected.toggle()
        
        switch recipeViewModel.isSaved {
            
        case true:
            recipeViewModel.deleteFromSaveList()
            presentQuickAlert(title: "❎", message: "Removed from Saved Recipes")
            
        case false:
            recipeViewModel.addToSaveList()
            presentQuickAlert(title: "✅", message: "Added to Saved Recipes")
        }
        notificationCenter.post(name: NSNotification.Name(rawValue: "RefreshSavedList"), object: nil)
    }
    
}

// MARK: -TableView Delegate

extension RecipeDetailVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeViewModel?.ingredients?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: IngredientTableCell.identifier,
                                                       for: indexPath) as? IngredientTableCell
        else { fatalError("Could not load") }
        
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

//MARK: -ViewModelDelegate

extension RecipeDetailVC: RecipeViewModelDelegate {
    
    func updateView() {
        userName.text = recipeViewModel.user?.userName
        userImage.setImage(url: recipeViewModel.user?.userImageUrl)
        starButton.setTitle(recipeViewModel.averageScore, for: .normal)
        guard let reviewCount = recipeViewModel.reviewCount else { return }
        reviewCountLabel.text = "(\(reviewCount) Reviews)"
    }
    
}
