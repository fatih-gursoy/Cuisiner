//
//  RecipeDetailVC.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 25.04.2022.
//

import UIKit

class RecipeDetailVC: UIViewController, Storyboardable {
    
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
    weak var coordinator: RecipeDetailCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recipeViewModel.delegate = self
        configureTableView()
        configureUI()
        addTapGesture()
    }
    
    deinit {
        notificationCenter.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func configureTableView() {
        ingredientTable.delegate = self
        ingredientTable.dataSource = self
        ingredientTable.register(UINib(nibName: "IngredientPresentCell", bundle: nil),
                                 forCellReuseIdentifier: IngredientPresentCell.identifier)
        ingredientTable.layoutIfNeeded()
        
        let tableHeight = ingredientTable.contentSize.height
        ingredientTable.heightAnchor.constraint(equalToConstant: tableHeight).isActive = true
        
    }
    
    func configureUI() {
        recipeViewModel.fetchUser()
        recipeName.text = recipeViewModel?.recipeName
        categoryLabel.text = recipeViewModel.category
        serveLabel.text = recipeViewModel.recipe.serve
        cookTimeLabel.text = "\(recipeViewModel.cookTime) min"
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
    
    func notificationPost() {
        notificationCenter.post(name: NSNotification.Name(rawValue: "RefreshSavedList"), object: nil)
    }
    
    @IBAction func startClicked(_ sender: Any) {
        coordinator?.gotoStartCookVC(viewModel: self.recipeViewModel)
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
            presentQuickAlert(title: "❎", message: "Removed from Favorites")
        case false:
            recipeViewModel.addToSaveList()
            presentQuickAlert(title: "✅", message: "Added to Favorites")
        }
        notificationPost()
    }
    
    @IBAction func blockUserTapped(_ sender: Any) {
        let alertVC = CustomAlertVC(action: "Block User",
                                    message: AlertMessages.blockUser,
                                    image: UIImage(systemName: "person.crop.circle.fill.badge.xmark"))
        
        alertVC.delegate = self
        present(alertVC, animated: true)
    }
    
    @IBAction func reportButtonTapped(_ sender: Any) {
        
        let alertVC = CustomAlertVC(action: "Report",
                                    message: AlertMessages.report,
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
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: IngredientPresentCell.identifier, for: indexPath) as? IngredientPresentCell
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
        
        headerTitle.translatesAutoresizingMaskIntoConstraints = false
        return headerTitle
    }
    
}

//MARK: - ViewModelDelegate

extension RecipeDetailVC: RecipeViewModelDelegate {
    func updateView() {
        DispatchQueue.main.async { [weak self] in
            self?.userName.text = self?.recipeViewModel.user?.userName
            self?.userImage.setImage(url: self?.recipeViewModel.user?.userImageUrl)
            self?.starButton.setTitle(self?.recipeViewModel.averageScore, for: .normal)
            guard let reviewCount = self?.recipeViewModel.reviewCount else { return }
            self?.reviewCountLabel.text = "(\(reviewCount) Reviews)"
        }
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
        let vc = ProfileVC.instantiateFromStoryboard()
        vc.viewModel = userViewModel
        present(vc, animated: true)
    }
}
