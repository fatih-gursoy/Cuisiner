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
    
    var email: String? {
        self.string(forKey: "Email")
    }
    
    func setData(isRemember: Bool, email: String) {
        self.set(true, forKey: "isRemember")
        self.set(email, forKey: "Email")
    }
    
    func removeUserLoginData() {
        self.removeObject(forKey: "isRemember")
        self.removeObject(forKey: "Email")
    }
}
