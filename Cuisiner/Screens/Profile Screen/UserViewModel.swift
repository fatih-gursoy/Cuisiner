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
    
    var userImageUrl: String {
        guard let userImageUrl = user.userImageUrl else { return "" }
        return userImageUrl
    }

    var userName: String? { return user.userName }
    var userBio: String? { return user.bio }
    
    var recipeIdList: [String]?
    var recipeImageList: [String]?
    var recipeCount: String?
    var averageRating: String?
    
//MARK: - Functions
    
    func createNew() {
        service.update(from: .users, id: self.userId, self.user)
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
            self?.recipeIdList = recipes.compactMap { $0.id }
            self?.recipeImageList = recipes.compactMap { $0.foodImageUrl }
            
            if !(recipes.isEmpty) {
                self?.recipeCount = String(recipes.count)
                
                let ratingList = recipes.compactMap { $0.ratingList.map { $0 } }.reduce([], +)
                if !ratingList.isEmpty {
                    avg = Double(ratingList.compactMap { $0.score }.reduce(0, +)) / Double(ratingList.count)
                }
                self?.averageRating = String(format: "%.1f", avg)
            }
            self?.delegate?.updateView()
        }
    }
    
    func deleteAllUserData(completion: @escaping ((Bool) -> Void)) {
        
        let group = DispatchGroup()
        
        group.enter()
        service.delete(from: .users, with: userId) { success in
            if success { group.leave() }
        }
        
        group.enter()
        StorageService.shared.deleteImage(imageUrl: userImageUrl) { success in
            if success { group.leave() }
        }
        
        group.enter()
        if let recipeIdList = recipeIdList {
            _ = recipeIdList.map { group.enter()
                service.delete(from: .recipes, with: $0) { success in
                if success { group.leave() }
            }}
            group.leave()
        }
        
        group.enter()
        if let recipeImageList = recipeImageList {
            _ = recipeImageList.map { group.enter()
                StorageService.shared.deleteImage(imageUrl: $0) { success in
                if success { group.leave() }
            }}
            group.leave()
        }
        
        group.notify(queue: .main) {
            completion(true)
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
