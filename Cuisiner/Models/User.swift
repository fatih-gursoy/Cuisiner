//
//  Credentials.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 30.03.2022.
//

import Foundation

struct User: Codable {
    
    var userId: String?
    var userName: String?
    var userNameLowercased: String?
    var email: String?
    var userImageUrl: String?
    var bio: String?
    
    enum CodingKeys: String, CodingKey {
        
        case userId
        case userName
        case userNameLowercased
        case email
        case userImageUrl
        case bio
        
    }
}
