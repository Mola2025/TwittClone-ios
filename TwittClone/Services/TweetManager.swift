//
//  TweetManager.swift
//  TwittClone
//
//  Created by David Molano on 2025-11-08.
//

import Combine
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import Foundation
import UIKit

class TweetManager: ObservableObject {
    @Published var tweets: [TweetModel] = []
    private let db = Firestore.firestore()
    private let storage = Storage.storage()

    // Create Tweet Method

    func createTweet(
        content: String,
        image: UIImage? = nil,
        completion:
            @escaping (
                Result<String, Error>
            ) -> Void
    ) {
        guard let currentUser = Auth.auth().currentUser else {
            completion(.failure(SimpleError("User not authenticated")))
            return
        }

        getUserData(userId: currentUser.uid) {
            result in
            switch result {
            case .success(let twitterUser):
                let username = twitterUser?.username ?? "Anonymous"

                // If there is an image upload it first and after save it
                if let image = image {
                    self.uploadTweetImage(image: image) {
                        result in
                        switch result {
                        case .success(let imageUrl):
                            self.saveTweettoFirestore(
                                userId: currentUser.uid,
                                username: username,
                                content: content,
                                imageURL: imageUrl,
                                completion: completion
                            )
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                } else {
                    //Tweet without image
                    self.saveTweettoFirestore(
                        userId: currentUser.uid,
                        username: username,
                        content: content,
                        imageURL: nil,
                        completion: completion
                    )
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    //  Get userID for saving the tweet with his id included
    private func getUserData(
        userId: String,
        completion: @escaping (Result<TwitterUser?, Error>) -> Void
    ) {
        db.collection("users").document(userId).getDocument {
            snapshot,
            error in
            if let error = error {
                completion(
                    .failure(
                        SimpleError(
                            "Error fetching user data: \(error.localizedDescription)"
                        )
                    )
                )
                return
            }

            do {
                let twitteruser = try snapshot?.data(as: TwitterUser.self)
                completion(.success(twitteruser))
            } catch {
                completion(
                    .failure(
                        SimpleError(
                            "Error getting user data:  \(error.localizedDescription)"
                        )
                    )
                )
            }
        }

    }

    // uploadTweetImage Method (This method allows me to insert and save an image in the firestore storage for the tweet)

    private func uploadTweetImage(
        image: UIImage?,
        completion:
            @escaping (
                Result<String, Error>
            ) -> Void
    ) {
        guard let image = image,
            let imageData = image.jpegData(compressionQuality: 0.5),
            let currentUser = Auth.auth().currentUser
        else {
            completion(.failure(SimpleError("User not authenticated")))
            return
        }

        let tweetImageRef =
            "tweet_images/\(currentUser.uid)_\(UUID().uuidString).jpg"
        let storageRef = Storage.storage().reference().child(tweetImageRef)

        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        storageRef.putData(imageData, metadata: metadata) { _, error in
            if let error = error {
                completion(
                    .failure(
                        SimpleError(
                            "Error uploading the image: \(error.localizedDescription)"
                        )
                    )
                )
                return
            }

            storageRef.downloadURL { (url, error) in
                if let error = error {
                    completion(
                        .failure(
                            SimpleError(
                                "Error getting download the URL: \(error.localizedDescription)"
                            )
                        )
                    )
                    return
                } else if let url = url {
                    completion(.success(url.absoluteString))
                }
            }
        }

    }

    // saveTweettoFirestore to save the tweet in the collection of tweets in firestore

    private func saveTweettoFirestore(
        userId: String,
        username: String,
        content: String,
        imageURL: String?,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        let tweetData: [String: Any] = [
            "userId": userId,
            "username": username,
            "content": content,
            "imageURL": imageURL,
            "timestamp": FieldValue.serverTimestamp(),
            "likes": 0,
        ]

        db.collection("tweets").addDocument(data: tweetData) { (error) in
            if let error = error {
                completion(
                    .failure(
                        SimpleError(
                            "Error saving the tweet: \(error.localizedDescription)"
                        )
                    )
                )
                return
            } else {
                completion(.success("Tweet saved successfully"))
            }

        }
    }

    func fetchTweets(
        completion: @escaping (Result<[TweetModel], Error>) -> Void
    ) {
        db.collection("tweets").order(by: "timestamp", descending: true)
            .addSnapshotListener { snapshot, error in // El listener permite que siempre se vean reflejados los cambios en tiempo real
                if let error = error {
                    completion(
                        .failure(
                            SimpleError(
                                "Error fetching tweets: \(error.localizedDescription)"
                            )
                        )
                    )
                    return
                }

                do {
                    let tweets =
                        try snapshot?.documents.compactMap {
                            try $0.data(as: TweetModel.self)
                        } ?? []
                    DispatchQueue.main.async {
                        self.tweets = tweets
                    }
                    completion(.success(tweets))
                } catch {
                    completion(
                        .failure(
                            SimpleError(
                                "Error decoding tweets: \(error.localizedDescription)"
                            )
                        )
                    )
                }
            }

    }
}

