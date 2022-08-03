//
//  ProfileVC.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 16.06.2022.
//

import UIKit

class ProfileVC: UIViewController {
    
    @IBOutlet private weak var userImage: CustomImageView!
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var bioLabel: UILabel!
    @IBOutlet private weak var recipeCountLabel: UILabel!
    @IBOutlet private weak var averageRatingLabel: UILabel!
    @IBOutlet private weak var editButton: UIButton!
    @IBOutlet private weak var bioText: UITextView!
    
    private var viewModel: UserViewModel
    
//MARK: - Custom init
    
    init?(coder: NSCoder, viewModel: UserViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

//MARK: - Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        configureNavBar()
        updateUI()
    }
    
    func updateUI() {
        viewModel.delegate = self
        viewModel.load()
        if viewModel.userId != AuthManager.shared.userId {editButton.isHidden = true}
    }
    
    func configureNavBar() {
        let buttonImage =  #imageLiteral(resourceName: "XMark")
        let barButton = UIBarButtonItem(image: buttonImage, style: .plain, target: self, action: #selector(closeTapped))
        self.navigationItem.rightBarButtonItem = barButton
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    @objc func closeTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editButtonClicked(_ sender: Any) {
        self.navigationController?.pushViewController(ProfileEditVCBuilder.build(viewModel: self.viewModel),
                                                      animated: true)
    }
}

extension ProfileVC: UserViewModelDelegate {

    func updateView() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {return}
            self.userImage.setImage(url: self.viewModel.userImageUrl)
            self.usernameLabel.text = self.viewModel.userName
            self.bioText.text = self.viewModel.userBio
            self.recipeCountLabel.text = self.viewModel.recipeCount
            self.averageRatingLabel.text = self.viewModel.averageRating
        }
    }
}
