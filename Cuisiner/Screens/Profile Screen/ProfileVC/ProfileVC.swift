//
//  ProfileVC.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 16.06.2022.
//

import UIKit

class ProfileVC: UIViewController, Storyboardable {
    
    @IBOutlet private weak var userImage: CustomImageView!
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var recipeCountLabel: UILabel!
    @IBOutlet private weak var averageRatingLabel: UILabel!
    @IBOutlet private weak var bioField: UITextView!
    
    var viewModel: UserViewModel!
    weak var coordinator: ProfileCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        configureNavBar()
        updateUI()
    }
    
//MARK: - Functions
    
    func updateUI() {
        viewModel.delegate = self
        viewModel.fetchRecipes()        
    }
    
    func configureNavBar() {
        
        let editButton = UIBarButtonItem(image: #imageLiteral(resourceName: "editProfile"), style: .plain, target: self,
                                         action: #selector(editButtonTapped))

        let closeButton = UIBarButtonItem(image: #imageLiteral(resourceName: "xmark"), style: .plain, target: self,
                                          action: #selector(closeTapped))

        self.navigationItem.rightBarButtonItems = [closeButton, editButton]
    }

    @objc func closeTapped() {
        coordinator?.didFinished()
    }

    @objc func editButtonTapped() {
        coordinator?.gotoProfileEdit(viewModel: self.viewModel)
    }
}

extension ProfileVC: UserViewModelDelegate {

    func updateView() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {return}
            self.userImage.setImage(url: self.viewModel.userImageUrl)
            self.usernameLabel.text = self.viewModel.userName
            self.bioField.text = self.viewModel.userBio
            self.recipeCountLabel.text = self.viewModel.recipeCount
            self.averageRatingLabel.text = self.viewModel.averageRating
        }
    }
}
