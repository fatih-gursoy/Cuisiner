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
    
    var userAuth = Auth.auth()
    
    private init() { }
    
}

