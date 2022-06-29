//
//  ProfileEditVC.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 18.06.2022.
//

import UIKit

class ProfileEditVC: UIViewController {

    @IBOutlet weak var profileImage: CustomImageView!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var bioField: UITextView!
    
    var userViewModel = UserViewModel()
    private var storage = StorageService.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureImagePicker()
        configureUI()
 
    }
    
    func configureUI() {
        
        profileImage.setImage(url: userViewModel.userImageUrl)
        usernameField.text = userViewModel.userName
        emailField.text = userViewModel.user?.email
        bioField.text = userViewModel.userBio
        bioField.layer.cornerRadius = 10.0
        bioField.layer.borderWidth = 1.0
        bioField.layer.borderColor = UIColor.lightGray.cgColor
        
    }
    


    @IBAction func updateTapped(_ sender: Any) {
        
        guard let user = userViewModel.user,
              let userImageURL = userViewModel.userImageUrl,
              let newImage = profileImage.image
        else { return }
            
        if !profileImage.isSame(with: userImageURL) {
            
            storage.imageUpload(to: .userImages, id: user.userId!, image: newImage) { imageURL in
                
                self.updateUserInfo()
                self.userViewModel.user?.userImageUrl = imageURL
                self.userViewModel.updateUser()
            }
        } else {
            updateUserInfo()
            self.userViewModel.updateUser()
        }
        
        presentAlert(title: "Status", message: "Profile Updated") { _ in
            self.navigationController?.popToRootViewController(animated: true)
        }
        
    }
    
    func updateUserInfo() {
        
        if self.usernameField.text != self.userViewModel.userName ||
            self.bioField.text != self.userViewModel.userBio
        {
            self.userViewModel.user?.bio = self.bioField.text
            
            guard let newUsername = self.usernameField.text else { return }
            AuthManager.shared.changeUsername(with: newUsername)
            self.userViewModel.user?.userName = newUsername
            self.userViewModel.user?.userNameLowercased = newUsername.lowercased()
            
        }
        
    }
    
    
    @IBAction func changePasswordTapped(_ sender: Any) {
        
        let updatePasswordVC = PasswordVC()
        updatePasswordVC.modalPresentationStyle = .overCurrentContext
        updatePasswordVC.modalTransitionStyle = .crossDissolve
        present(updatePasswordVC, animated: true)
        
    }
    

    
}

// MARK: - ImagePickerDelegate

extension ProfileEditVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func configureImagePicker() {
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        profileImage.addGestureRecognizer(gesture)
        profileImage.isUserInteractionEnabled = true
    }

    @objc func imageTapped() {
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        profileImage.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)

    }
    
}
