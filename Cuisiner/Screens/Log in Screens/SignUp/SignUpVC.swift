//
//  SignUpVC.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 9.03.2022.
//

import UIKit

protocol SignUpDelegate: AnyObject {
    func didUserSignUp()
}

class SignUpVC: UIViewController {

    @IBOutlet weak private var emailText: UITextField!
    @IBOutlet weak private var passwordText: UITextField!
    @IBOutlet weak private var passwordAgainText: UITextField!
    @IBOutlet weak private var usernameText: UITextField!
    @IBOutlet weak private var profileImage: CustomImageView!
    
    weak var delegate: SignUpDelegate?
    private var authManager = AuthManager.shared
    private var storage = StorageService.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboard()
        usernameText.delegate = self
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        
        if emailText.text != "" && passwordText.text != "" {
            if passwordText.text == passwordAgainText.text {
                authManager.updateCredentials(email: emailText.text!,
                                              password: passwordText.text!)
                
                authManager.signUp { [weak self] success in
                    if (success) {
                        self?.saveUser()
                        self?.delegate?.didUserSignUp()
                    } else {
                        if let errorMessage = self?.authManager.errorMessage {
                            self?.presentAlert(title: "Error", message: errorMessage, completion: nil)
                        }
                    }
                }
            }
        } else {
            presentAlert(title: "Couldn't Sign Up", message: "Please fill credentials", completion: nil)
        }
    }
    
    func saveUser() {
        let newUser = authManager
        if let username = usernameText.text {
            newUser.changeUsername(with: username)
        }        
        guard let userImage = profileImage.image, let uid = newUser.userId else {return}
        storage.imageUpload(to: .userImages,id: uid, image: userImage) { imageUrl in
            let user = User(userId: newUser.userId,
                            userName: newUser.userName,
                            userNameLowercased: newUser.userName?.lowercased(),
                            email: newUser.userEmail,
                            userImageUrl: imageUrl,
                            blockedUsers: [],
                            recipeBlackList: [])
            
            let userViewModel = UserViewModel(user: user)
            userViewModel.createNew()
        }
    }
    
}

extension SignUpVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBAction func didTap(_ sender: UITapGestureRecognizer) {
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

extension SignUpVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let stringLenght = textField.text?.count ?? 0
        if range.length + range.location > stringLenght { return false }
        let maxLenght = stringLenght + string.count - range.length
        return maxLenght <= 20
    }
}
