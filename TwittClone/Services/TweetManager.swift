//
//  TweetManager.swift
//  TwittClone
//
//  Created by David Molano on 2025-11-08.
//

import Combine
import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage


class TweetManager: ObservableObject {
    @Published var tweets: [TweetModel] = []
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    
    
    
}
