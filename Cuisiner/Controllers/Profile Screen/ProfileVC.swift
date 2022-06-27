//
//  ProfileVC.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 16.06.2022.
//

import UIKit

class ProfileVC: UIViewController {
    
    @IBOutlet weak var userImage: CustomImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var recipeCountLabel: UILabel!
    @IBOutlet weak var averageRatingLabel: UILabel!
    
    var userViewModel = UserViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavBar()
        updateUI()
        
    }
    
    func updateUI() {
        
        userViewModel.delegate = self
        userViewModel.fetchUser()
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
        
        guard let profileEditVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileEditVC") as? ProfileEditVC else { fatalError("Error")}
        
        profileEditVC.userViewModel = self.userViewModel
        
        self.navigationController?.pushViewController(profileEditVC, animated: true)

    }
    

}

extension ProfileVC: UserViewModelDelegate {
    
    func updateView() {
        
        userImage.setImage(url: userViewModel.userImageUrl)
        usernameLabel.text = userViewModel.userName
        bioLabel.text = userViewModel.userBio
        recipeCountLabel.text = userViewModel.recipeCount
        averageRatingLabel.text = userViewModel.averageRating
        
    }
    
}
