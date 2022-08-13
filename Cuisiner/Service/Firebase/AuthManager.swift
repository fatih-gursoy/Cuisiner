//
//  AuthManager.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 30.03.2022.
//

import Foundation
import Firebase

class AuthManager {
    
    static let shared: AuthManager = AuthManager()
    
    private var userAuth = Auth.auth()
    private var email = ""
    private var password = ""
    private init() {}

    var user: User?
    var errorMessage: String?
    var userId: String? { return userAuth.currentUser?.uid }
    var userName: String? { return userAuth.currentUser?.displayName }
    var userEmail: String? { return userAuth.currentUser?.email }
}

extension AuthManager {
    
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
                completion(true)
            }
        }
    }
    
    func fetchUser(completion: @escaping (Bool) -> Void) {
        
        guard let userId = self.userId else {return}
        FirebaseService.shared.fetchByField(from: .users, queryField: "userId",
                                            queryParam: userId) { [weak self] (users: [User]) in
            
            guard let user = users.first else {return}
            self?.user = user
            completion(true)
        }
    }
    
    func signUp(completion: @escaping(_ success: Bool) -> Void) {
        userAuth.createUser(withEmail: email, password: password) { authData, error in
            if error != nil {
                self.errorMessage = error?.localizedDescription
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    func changeUsername(with newUsername: String) {
        let changeRequest = userAuth.currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = newUsername
        changeRequest?.commitChanges()
    }
    
    func updatePassword(currentPassword: String, newPassword: String,
                        completion: @escaping(_ success: Bool) -> Void) {
        
        reAuthenticate(password: currentPassword) { success in
            if success {
                self.userAuth.currentUser?.updatePassword(to: newPassword, completion: { error in
                    if let error = error {
                        self.errorMessage = error.localizedDescription
                        completion(false)
                    } else {
                        completion(true)
                    }
                })
            } else {
                completion(false)
            }
        }
    }
    
    func passwordReset(email: String, completion: @escaping(_ success: Bool) -> Void) {
        userAuth.sendPasswordReset(withEmail: email) { error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                completion(false)
            } else {
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
    
    func deleteAccount(password: String, completion: @escaping(_ success: Bool) -> Void) {
        
        reAuthenticate(password: password) { success in
            if success {
                self.userAuth.currentUser?.delete(completion: { error in
                    if let error = error {
                        self.errorMessage = error.localizedDescription
                        completion(false)
                    } else {
                        completion(true)
                    }
                })
            } else {
                completion(false)
            }
        }
    }
    
    private func reAuthenticate(password: String, completion: @escaping(_ success: Bool) -> Void) {
        
        guard let userEmail = self.userEmail else { return }
        let credentials = Firebase.EmailAuthProvider.credential(withEmail: userEmail, password: password)

        userAuth.currentUser?.reauthenticate(with: credentials, completion: { authData, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                completion(false)
            } else {
                completion(true)
            }
        })
    }
}

