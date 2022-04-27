//
//  StorageService.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 5.04.2022.
//

import Foundation
import Firebase

class StorageService {
    
    static let shared: StorageService = StorageService()
    private let storage = Storage.storage()
    private lazy var foodStorageRef = storage.reference().child("Food_images")
    
    private init() { }

}

extension StorageService {
    
    func imageUpload(image: UIImage, completion: @escaping ((String?) -> Void)) {
     
        if let data = image.jpegData(compressionQuality: 0.5) {
            
            let uuid = UUID().uuidString
            let imageRef = foodStorageRef.child("\(uuid).jpeg")
            
            imageRef.putData(data, metadata: nil) { data, error in
                
                if error != nil {
                    print(error?.localizedDescription as Any)
                } else {
                    imageRef.downloadURL { url, error in
                        if error == nil {
                            let imageUrl = url!.absoluteString
                            completion(imageUrl)
                        }
                    }
                }
            }
        }
    }
    
}


