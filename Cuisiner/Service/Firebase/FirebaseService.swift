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

    func update<T: Encodable>(from collection: myCollection, id: String, _ model: T)
    func delete(from collection: myCollection, with id: String, completion: @escaping (Bool) -> Void)
    func fetchData<T: Decodable>(from collection: myCollection, completion: @escaping ([T]) -> Void)
    
    func fetchByField<T: Decodable>(from collection: myCollection, queryField: String, queryParam: String, completion: @escaping ([T]) -> Void)
    
    func getDocumentByField<T: Decodable>(from collection: myCollection, queryField: String, queryParam: String, completion: @escaping ([T]) -> Void) 

}

class FirebaseService {
    static let shared: FirebaseService = FirebaseService()
    private let db = Firestore.firestore()
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
    
    func fetchByField<T: Decodable>(from collection: myCollection, queryField: String, queryParam: String, completion: @escaping ([T]) -> Void) {
        
        db.collection(collection.name).whereField(queryField, isEqualTo: queryParam as Any)
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
    
    func getDocumentByField<T: Decodable>(from collection: myCollection, queryField: String, queryParam: String, completion: @escaping ([T]) -> Void) {
        
        db.collection(collection.name).whereField(queryField, isEqualTo: queryParam as Any)
            .getDocuments { querySnapshot, error in
                    
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
    
    func update<T: Encodable>(from collection: myCollection, id: String, _ model: T) {
        do {
            try db.collection(collection.name).document(id).setData(from: model)
        } catch {
            print("\(error)")
        }
    }
    
    func delete(from collection: myCollection, with id: String, completion: @escaping ((Bool) -> Void) ) {
        
        db.collection(collection.name).document(id).delete { error in
            if let error = error {
                print("Document doesn't exist: \(error)")
            } else {
                completion(true)
            }
        }
        
//        db.collection(collection.name).whereField("id", isEqualTo: id as Any)
//            .getDocuments { querySnapshot, error in
//
//            if let error = error {
//                print("Document doesn't exist: \(error)")
//                completion(false)
//            } else {
//                if let document = querySnapshot?.documents.first {
//                    document.reference.delete()
//                    completion(true)
//                }
//            }
//        }
    }
}


