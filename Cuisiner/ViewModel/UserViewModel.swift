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
    
    var userAuth = AuthManager.shared.userAuth
    
    var errorMessage: String?
    
    private var email = ""
    private var password = ""
    
    private var credentials = Credentials() {
        didSet {
            email = credentials.email
            password = credentials.password
        }
    }
    
    func updateCredentials(email: String, password: String) {
        credentials.email = email
        credentials.password = password
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