//
//  User.swift
//  MyContacts
//
//  Created by mmt5885 on 08/08/19.
//  Copyright © 2019 Santosh Tewari. All rights reserved.
//

import Foundation

struct Contact: Codable {
    let id: Int
    let firstName, lastName: String
    let email, phoneNumber: String?
    let profilePic: String
    let favorite: Bool
    let createdAt, updatedAt: String?
    
    var fullName:String {
        get {
            return "\(firstName) \(lastName)"
        }
    }
    
    var profileURL: String {
        return Constant.URL.baseURL + self.profilePic
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case phoneNumber = "phone_number"
        case profilePic = "profile_pic"
        case favorite
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}