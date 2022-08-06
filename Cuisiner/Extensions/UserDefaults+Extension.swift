//
//  UserDefaults+Extension.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 31.07.2022.
//

import Foundation

extension UserDefaults {
    
    var isRemember: Bool {
        self.bool(forKey: "isRemember")
    }
    
    var username: String? {
        self.string(forKey: "Username")
    }
    
    func setData(isRemember: Bool, email: String) {
        self.set(true, forKey: "isRemember")
        self.set(email, forKey: "Username")
    }
    
    func removeUserLoginData() {
        
        self.removeObject(forKey: "isRemember")
        self.removeObject(forKey: "Username")
        self.removeObject(forKey: "Password")
    }
    
    
}
