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
    var ingredients: [Ingredient]
    var instructions: [Instruction]
    var foodImageUrl: String?
    var ratingList: [Rating]?
    var reporterList: [String]?
    
    enum CodingKeys: String, CodingKey {
        case ownerId
        case id
        case name
        case serve
        case cookTime
        case category
        case ingredients
        case instructions
        case foodImageUrl
        case ratingList = "Rating List"
        case reporterList
    }
        
    enum Category: String, Codable, CaseIterable {
        case homeMeal = "Home Meal"
        case steak = "Steak"
        case chicken = "Chicken"
        case seaFood = "Sea Food"
        case pizza = "Pizza"
        case burger = "Burger"
        case pasta = "Pasta"
        case kebap = "Kebap"
        case toast = "Toast or Sandwich"
        case vegan = "Vegan"
        case salad = "Salad"
        case appetizer = "Appetizer"
        case soup = "Soup"
        case breakfast = "Breakfast"
        case bakery = "Bakery"
        case snack = "Snack"
        case dessert = "Dessert"
        case babyFood = "Baby Food"
        case drink = "Drink"
        case otherFastFood = "Other Food"
    }
}

struct Ingredient: Codable {
    var name: String?
}

struct Instruction: Codable {
    var text: String?
}

struct Rating: Codable {
    var userId: String?
    var score: Int?
}






