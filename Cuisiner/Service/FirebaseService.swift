//
//  FirebaseService.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 24.03.2022.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

protocol FirebaseServiceProtocol: AnyObject {

    func add(with recipe: Recipe)
    func update(recipe: Recipe)
    func delete(with id: String)
    func fetchAllRecipes(completion: @escaping ([Recipe]?) -> Void)
    func fetchMyRecipes(completion: @escaping ([Recipe]?) -> Void)

}

class FirebaseService {
    
    static let shared: FirebaseService = FirebaseService()
    
    private let db = Firestore.firestore()
    private let recipeCollection = "Recipes"
    private let storageService = StorageService.shared
    
    private init() { }
    
}

extension FirebaseService: FirebaseServiceProtocol {

    func add(with recipe: Recipe) {
                
        do {
            try _ = db.collection(recipeCollection).addDocument(from: recipe.self)
        } catch {
            print("Add document failed: \(error)")
        }
        
    }
    
    func update(recipe: Recipe) {
        
        db.collection(recipeCollection).whereField("id", isEqualTo: recipe.id as Any)
            .getDocuments { querySnapshot, error in
                
            if let error = error {
                print("Document doesn't exist \(error)")
            } else {
                
                if let document = querySnapshot?.documents.first {
                    do {
                        try document.reference.setData(from: recipe)
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
    
    func delete(with id: String) {
        
        db.collection(recipeCollection).whereField("id", isEqualTo: id as Any)
            .getDocuments { querySnapshot, error in
                
                if let error = error {
                    print("Document doesn't exist \(error)")
                } else {
                    
                    if let document = querySnapshot?.documents.first {
                        document.reference.delete()
                    }
                }
        }
    }
    

    func fetchAllRecipes(completion: @escaping ([Recipe]?) -> Void) {
        
        db.collection(recipeCollection).addSnapshotListener { querySnapshot, error in
                
            if let error = error {
                print("Document doesn't exist \(error)")
            } else {
                
                if let documents = querySnapshot?.documents {
                        
                    let recipes = documents.compactMap { doc in
                        return try? doc.data(as: Recipe.self) }
                    completion(recipes)
                }
            }
        }
    }
    
    func fetchMyRecipes(completion: @escaping ([Recipe]?) -> Void) {
        
        guard let ownerId = CurrentUser.shared.userId else {return}

        db.collection(recipeCollection).whereField("ownerId", isEqualTo: ownerId as Any)
            .addSnapshotListener { querySnapshot, error in
                
            if let error = error {
                print("Document doesn't exist \(error)")
            } else {
                
                if let documents = querySnapshot?.documents {
                        
                    let recipes = documents.compactMap { doc in
                        return try? doc.data(as: Recipe.self) }
                    completion(recipes)
                }
            }
        }
    }
    

    
}


