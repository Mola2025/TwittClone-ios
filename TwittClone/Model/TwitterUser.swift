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
    var Fullname: String
    var Username: String
    var Bio: String
    var ProfileImageURL: String?
    
    // Constructor
    init(
        id: String? = nil,
        email: String,
        Fullname: String,
        Username: String,
        Bio: String,
        ProfileImageURL: String? = nil
    ) {
        self.id = id
        self.email = email
        self.Fullname = Fullname
        self.Username = Username
        self.Bio = Bio
        self.ProfileImageURL = ProfileImageURL
    }
    
}
