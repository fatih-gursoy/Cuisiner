//
//  LoginViewModel.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 30.03.2022.
//

import Foundation

class UserViewModel {

    var user: User
    
    private var service: FirebaseServiceProtocol {
        return FirebaseService.shared
    }
    
    init(user: User) {
        self.user = user
    }
    
}

extension UserViewModel {
    
    func createNew() {
        service.addNew(to: .users, self.user)
    }
    
    func updateUser() {
        guard let userId = self.user.userId else {return}
        service.update(from: .users, id: userId, self.user)
    }
    
}
