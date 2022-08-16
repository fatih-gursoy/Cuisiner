//
//  Database.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 27.04.2022.
//

import Foundation

enum myCollection {
    case recipes
    case users
}

extension myCollection {
    
    var name: String {
        switch self {
        case .recipes:
            return "Recipes"
        case .users:
            return "Users"
        }
    }
}
    
enum myStorage {
    case foodImages
    case userImages
}

extension myStorage {
    
    var name: String {
        switch self {
        case .foodImages:
            return "Food_images"
        case .userImages:
            return "User_images"
        }
    }
}
