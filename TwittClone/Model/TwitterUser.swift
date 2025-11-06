//
//  TwitterUser.swift
//  TwittClone
//
//  Created by David Molano on 2025-11-04.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

struct TwitterUser: Codable, Identifiable{
    
    @DocumentID var id: String?
    let email: String
    var fullname: String
    var username: String
    var bio: String?
    var profileImageURL: String?
    var followers: Int
    var following: Int
    
    // Constructor
    init(
        id: String? = nil,
        email: String,
        Fullname: String,
        Username: String,
        Bio: String? = nil,
        ProfileImageURL: String? = nil
    ) {
        self.id = id
        self.email = email
        self.fullname = Fullname
        self.username = Username
        self.bio = Bio
        self.profileImageURL = ProfileImageURL
        self.followers = 0
        self.following = 0
    }
    
}
