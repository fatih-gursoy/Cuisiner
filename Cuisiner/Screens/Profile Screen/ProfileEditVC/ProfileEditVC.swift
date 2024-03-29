//
//  ProfileEditVC.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 18.06.2022.
//

import UIKit

class ProfileEditVC: UIViewController, Storyboardable {

    @IBOutlet private weak var profileImage: CustomImageView!
    @IBOutlet private weak var usernameField: UITextField!
    @IBOutlet private weak var emailField: UITextField!
    @IBOutlet private weak var bioField: UITextView!
    @IBOutlet private weak var scrollView: UIScrollView!
    
    private var storage = StorageService.shared
    
    var viewModel: UserViewModel!
    weak var coordinator: ProfileCoordinator?
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureImagePicker()
        configureUI()
        configureMenu()
        hideKeyboard()
    }
    
//MARK: - Functions

    func configureUI() {
        self.title = "Edit Profile"
        profileImage.setImage(url: viewModel.userImageUrl)
        usernameField.text = viewModel.userName
        emailField.text = viewModel.user.email
        bioField.text = viewModel.userBio
        bioField.layer.cornerRadius = 10.0
        bioField.layer.borderWidth = 1.0
        bioField.layer.borderColor = UIColor.lightGray.cgColor
    }

    @IBAction func updateTapped(_ sender: Any) {
        
        guard let newImage = profileImage.image else { return }            
        if !profileImage.isSame(with: viewModel.userImageUrl) {
            storage.imageUpload(to: .userImages, id: viewModel.userId, image: newImage) { imageURL in
                self.updateUserInfo()
                self.viewModel.user.userImageUrl = imageURL
                self.viewModel.updateUser()
            }
        } else {
            updateUserInfo()
            self.viewModel.updateUser()
        }
        presentAlert(title: "Status", message: "Profile Updated") { _ in
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func updateUserInfo() {
        if self.usernameField.text != self.viewModel.userName ||
            self.bioField.text != self.viewModel.userBio
        {
            self.viewModel.user.bio = self.bioField.text
            guard let newUsername = self.usernameField.text else { return }
            AuthManager.shared.changeUsername(with: newUsername)
            self.viewModel.user.userName = newUsername
            self.viewModel.user.userNameLowercased = newUsername.lowercased()
        }
    }
    
    @IBAction func changePasswordTapped(_ sender: Any) {
        let updatePasswordVC = ChangePasswordVC()
        present(updatePasswordVC, animated: true)
    }
    
    @IBAction func deleteAccountTapped(_ sender: Any) {
        let deleteConfirmationVC = AccountDeleteVC()
        deleteConfirmationVC.viewModel = self.viewModel
        deleteConfirmationVC.delegate = self
        present(deleteConfirmationVC, animated: true)
    }
    
}

protocol ProfileEditVCDelegate: AnyObject {
    func gotoWelcome()
}

extension ProfileEditVC: ProfileEditVCDelegate {
    
    func gotoWelcome() {
        coordinator?.logOut()
    } 

//MARK: - NAvbar Configure

    func configureMenu() {
                       
        let blockedUsers = UIAction(title: "Blocked Users",
                                    image: UIImage(systemName: "person.crop.circle.fill.badge.xmark")) { [weak self] _ in
            self?.coordinator?.gotoBlockedUsers()
        }
        
        let menu = UIMenu(options: .displayInline, children: [blockedUsers])
        let menuButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), menu: menu)
        self.navigationItem.rightBarButtonItem = menuButton
    }
}

// MARK: - ImagePicker Delegate

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
