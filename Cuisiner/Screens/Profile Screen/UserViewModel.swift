//
//  LoginViewModel.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 30.03.2022.
//

import Foundation

protocol UserViewModelDelegate: AnyObject {
    func updateView()
}

class UserViewModel {

    var user: User
    weak var delegate: UserViewModelDelegate?
    
    private var service: FirebaseServiceProtocol
    
    init(user: User, service: FirebaseServiceProtocol = FirebaseService.shared) {
        self.service = service
        self.user = user
    }
    
    var userId: String {
        guard let userId = user.userId else {return ""}
        return userId
    }

    var userName: String? {
        return user.userName
    }
    
    var userImageUrl: String? {
        return user.userImageUrl
    }
    
    var userBio: String? {
        return user.bio
    }
    
    var recipeCount: String?
    var averageRating: String?
    
//MARK: - Functions
    
    func createNew() {
        service.addNew(to: .users, self.user)
    }
    
    func updateUser() {
        guard let userId = self.user.userId else {return}
        service.update(from: .users, id: userId, self.user)
        fetchUser()
    }
    
    func fetchRecipes() {
        service.fetchByField(from: .recipes,
                             queryField: "ownerId",
                             queryParam: userId) { [weak self] (recipes: [Recipe]) in
                
            var avg = 0.0
            
            if !(recipes.isEmpty) {
                let ratingList = recipes.compactMap { $0.ratingList.map { $0 } }.reduce([], +)
                avg = Double(ratingList.compactMap { $0.score }.reduce(0, +)) / Double(ratingList.count)
            }
            self?.averageRating = String(format: "%.1f", avg)
            self?.recipeCount = String(recipes.count)
            self?.delegate?.updateView()
        }
    }
    
//MARK: - Private Functions
    private func fetchUser() {
        service.fetchByField(from: .users,
                             queryField: "userId",
                             queryParam: userId) { [weak self] (users: [User]) in
            guard let user = users.first else {return}
            self?.user = user
            self?.delegate?.updateView()
        }
    }
}
