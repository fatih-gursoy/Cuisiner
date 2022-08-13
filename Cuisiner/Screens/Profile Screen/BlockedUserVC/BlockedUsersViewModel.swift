//
//  UsersViewModel.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 12.08.2022.
//

import Foundation

protocol BlockedUsersViewModelDelegate: AnyObject {
    func updateView()
}

class BlockedUsersViewModel {

    var users: [User]?
    var currentUser = AuthManager.shared.user

    weak var delegate: BlockedUsersViewModelDelegate?
    private var service: FirebaseServiceProtocol
    
    init(service: FirebaseServiceProtocol = FirebaseService.shared) {
        self.service = service
    }
    
//MARK: - Functions

    func fetchUsers() {
        
        service.fetchData(from: .users) { [weak self] (users: [User]) in
            
            guard let blockedUsers = users.filter({ $0.userId == self?.currentUser?.userId }).first?.blockedUsers else { return }
            
            let users = users.filter { user in
                guard let userId = user.userId else { return false }
                return blockedUsers.contains(userId)
            }
            self?.users = users
            self?.delegate?.updateView()
        }
    }
    
    func removeBlock(userId: String) {
        guard let currentUser = currentUser else { return }
        let userViewModel = UserViewModel(user: currentUser)
        userViewModel.blockUserHandler(userId: userId)
    }
    
}
