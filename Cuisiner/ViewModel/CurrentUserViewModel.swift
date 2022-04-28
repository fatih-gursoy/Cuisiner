//
//  LoginViewModel.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 30.03.2022.
//

import Foundation

class UserViewModel {
     
    private let authManager: AuthManager
    
    init(authManager: AuthManager = AuthManager.shared) {
        self.authManager = authManager
    }
    
    private lazy var userAuth = authManager.userAuth
    var errorMessage: String?
    
    private var email = ""
    private var password = ""
    
    func updateCredentials(email: String, password: String) {
        self.email = email
        self.password = password
    }
    
    func signIn(completion: @escaping(_ success: Bool) -> Void) {

        userAuth.signIn(withEmail: email, password: password) { authData, error in
            
            if error != nil {
                self.errorMessage = error?.localizedDescription
                completion(false)
            } else {
                CurrentUser.shared.currentUser = authData?.user
                completion(true)
            }
        }
    }
    
    func signUp(completion: @escaping(_ success: Bool) -> Void) {
            
        userAuth.createUser(withEmail: email, password: password) { authData, error in
            
            if error != nil {
                 print(error?.localizedDescription ?? "")
                completion(false)
            } else {
                CurrentUser.shared.currentUser = authData?.user
                completion(true)
            }
        }
    
    }
    
    func signOut() {
        
        do {
            try userAuth.signOut()
        } catch {
            print("Can't signout")
        }
        
    }

}
