//
//  Recipe.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 15.03.2022.
//

import Foundation

struct Recipe: Codable {
      
    var ownerId: String?
    var id: String?
    var name: String?
    var serve: String?
    var cookTime: String?
    var category: Category
    var ingredients: [Ingredient]?
    var instructions: [Instruction]?
    
    
    enum CodingKeys: String, CodingKey {
        
        case ownerId
        case id
        case name
        case serve
        case cookTime
        case category
        case ingredients
        case instructions
        
    }
        
    enum Category: String, Codable {
        
        case homeMeal = "Home Meal"
        case desert
        case pizza
        case burger
        case otherFastFood = "Other Fast Food"
        case apperative
        case soup
        case drink
        
    }

}






