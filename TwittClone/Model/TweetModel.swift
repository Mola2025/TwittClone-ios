//
//  TweetModel.swift
//  TwittClone
//
//  Created by David Molano on 2025-11-08.
//

import Foundation
import FirebaseFirestore


struct TweetModel: Identifiable{
    @DocumentID var id: String?
    let userId: String
    let username: String
    var content: String
    var imageURL: String?
    let timestamp: Date
    var likes: Int
    
    // Constructor
    init(
        id: String? = nil,
        userId: String,
        username: String,
        content: String,
        imageURL: String? = nil,
        timestamp: Date
    ) {
        self.id = id
        self.userId = userId
        self.username = username
        self.content = content
        self.imageURL = imageURL
        self.timestamp = timestamp
        self.likes = 0
    }
    
}
