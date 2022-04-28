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

    func addNew<T: Encodable>(to collection: myCollection,_ model: T)
    func update<T: Encodable>(from collection: myCollection,id: String,_ model: T)
    func delete(from collection: myCollection, with id: String)
    
    func fetchData<T: Decodable>(from collection: myCollection, completion: @escaping ([T]) -> Void)

    func fetchByOwner<T: Decodable>(from collection: myCollection, ownerId: String, completion: @escaping ([T]) -> Void)
}

class FirebaseService {
    
    static let shared: FirebaseService = FirebaseService()
    
    private let db = Firestore.firestore()
    private let recipeCollection = "Recipes"
    private let storageService = StorageService.shared
    
    private init() { }
    
}

extension FirebaseService: FirebaseServiceProtocol {
        
    func fetchData<T: Decodable>(from collection: myCollection, completion: @escaping ([T]) -> Void) {

        db.collection(collection.name).addSnapshotListener { querySnapshot, error in
                
            if let error = error {
                print("Document doesn't exist \(error)")
            } else {
                
                if let documents = querySnapshot?.documents {
                        
                    let result = documents.compactMap { doc in
                        return try? doc.data(as: T.self) }
                    completion(result)
                }
            }
        }
    }
    
    func fetchByOwner<T: Decodable>(from collection: myCollection, ownerId: String, completion: @escaping ([T]) -> Void) {
        
        db.collection(collection.name).whereField("ownerId", isEqualTo: ownerId as Any)
            .addSnapshotListener { querySnapshot, error in
                
            if let error = error {
                print("Document doesn't exist \(error)")
            } else {
                
                if let documents = querySnapshot?.documents {
                        
                    let result = documents.compactMap { doc in
                        return try? doc.data(as: T.self) }
                    completion(result)
                }
            }
        }
    }
    
    
    func addNew<T: Encodable>(to collection: myCollection,_ model: T) {
        
        do {
            try _ = db.collection(collection.name).addDocument(from: model.self)
        } catch {
            print("Add document failed: \(error)")
        }
    }
    
    func update<T: Encodable>(from collection: myCollection,id: String,_ model: T) {
        
        db.collection(collection.name).whereField("id", isEqualTo: id as Any)
            .getDocuments { querySnapshot, error in
                
            if let error = error {
                print("Document doesn't exist \(error)")
            } else {
                
                if let document = querySnapshot?.documents.first {
                    do {
                        try document.reference.setData(from: model)
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
    
    
    func delete(from collection: myCollection, with id: String) {
        
        db.collection(collection.name).whereField("id", isEqualTo: id as Any)
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
    
}


