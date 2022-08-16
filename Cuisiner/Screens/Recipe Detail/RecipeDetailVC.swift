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
    @IBOutlet private weak var reportButton: UIButton!
    @IBOutlet private weak var blockButton: UIButton!
    @IBOutlet private weak var userStackView: UIStackView!
    @IBOutlet private weak var categoryLabel: UILabel!
    @IBOutlet private weak var cookTimeLabel: UILabel!
    @IBOutlet private weak var serveLabel: UILabel!
    
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
    
    deinit {
        notificationCenter.removeObserver(self)
    }
    
    func configureTableView() {
        ingredientTable.delegate = self
        ingredientTable.dataSource = self
        ingredientTable.register(UINib(nibName: "IngredientTableCell", bundle: nil),
                                 forCellReuseIdentifier: IngredientTableCell.identifier)
        ingredientTable.layoutIfNeeded()
        let tableHeight = ingredientTable.contentSize.height
        ingredientTable.heightAnchor.constraint(equalToConstant: tableHeight).isActive = true
    }
    
    func configureUI() {
        recipeViewModel.fetchUser()
        recipeName.text = recipeViewModel?.recipeName
        categoryLabel.text = recipeViewModel.category
        serveLabel.text = recipeViewModel.recipe.serve
        cookTimeLabel.text = recipeViewModel.cookTime
        recipeImage.setImage(url: recipeViewModel.recipe.foodImageUrl)
        starButton.setTitle(recipeViewModel?.averageScore, for: .normal)
        
        if recipeViewModel.recipe.ownerId == AuthManager.shared.userId {
            bookmarkButton.isHidden = true
            reportButton.isHidden = true
            blockButton.isHidden = true
        } else {
            bookmarkButton.isSelected = recipeViewModel.isSaved
        }
    }
    
    func configureNavBar() {
        let buttonImage =  #imageLiteral(resourceName: "xmark")
        let barButton = UIBarButtonItem(image: buttonImage, style: .plain,
                                        target: self, action: #selector(closeTapped))
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    func notificationPost() {
        notificationCenter.post(name: NSNotification.Name(rawValue: "RefreshSavedList"), object: nil)
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
        
        popupVC.doneTappedCompletion = { [weak self] in
            let score = popupVC.starView?.score
            let myRating = Rating(userId: AuthManager.shared.userId, score: score)
            self?.recipeViewModel?.updateRating(myRating)
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
        notificationPost()
    }
    
    @IBAction func blockUserTapped(_ sender: Any) {
        let alertVC = CustomAlertVC(action: "Block User",
                                    message: "Do you want to block user?",
                                    image: UIImage(systemName: "person.crop.circle.fill.badge.xmark"))
        
        alertVC.delegate = self
        present(alertVC, animated: true)
    }
    
    @IBAction func reportButtonTapped(_ sender: Any) {
        
        let alertVC = CustomAlertVC(action: "Report",
                                    message: "Do you want to report this content as inappropriate?",
                                    image: UIImage(systemName: "hand.thumbsdown.fill"))
        
        alertVC.delegate = self
        present(alertVC, animated: true)
    }
    
}

extension RecipeDetailVC: CustomAlertVCDelegate {
    
    func OkTapped(action: String?) {
        
        switch action {
            
        case "Block User":
            guard let user = AuthManager.shared.user,
                  let recipeOwnerId = recipeViewModel.user?.userId else {return}
            let userViewModel = UserViewModel(user: user)
            userViewModel.blockUserHandler(userId: recipeOwnerId)
            notificationPost()
            dismiss(animated: true)
            
        case "Report":
            guard let currentUserId = AuthManager.shared.userId else { return }
            recipeViewModel.addtoReportedRecipes(currentUserId: currentUserId)
        default:
            break
        }
    }
}

// MARK: - TableView Delegate

extension RecipeDetailVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let recipeViewModel = recipeViewModel else { return 0 }
        return recipeViewModel.ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: IngredientTableCell.identifier, for: indexPath) as? IngredientTableCell
        else { fatalError("Could not load") }
        
        cell.configureForPresent(ingredient:
                                    recipeViewModel?.ingredients[indexPath.row])
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

//MARK: - ViewModelDelegate

extension RecipeDetailVC: RecipeViewModelDelegate {
    func updateView() {
        userName.text = recipeViewModel.user?.userName
        userImage.setImage(url: recipeViewModel.user?.userImageUrl)
        starButton.setTitle(recipeViewModel.averageScore, for: .normal)
        guard let reviewCount = recipeViewModel.reviewCount else { return }
        reviewCountLabel.text = "(\(reviewCount) Reviews)"
    }
}

//MARK: - UserProfile Tap Gesture

extension RecipeDetailVC {
    
    func addTapGesture() {
        userStackView.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(toProfileVC))
        userStackView.addGestureRecognizer(gesture)
    }
    
    @objc func toProfileVC() {
        guard let user = recipeViewModel.user else {return}
        let userViewModel = UserViewModel(user: user)
        let vc = ProfileVCBuilder.build(viewModel: userViewModel)
        guard let presentationController = vc.presentationController as? UISheetPresentationController else {return}
        presentationController.detents = [.medium(), .large()]
        present(vc, animated: true)
    }
}
