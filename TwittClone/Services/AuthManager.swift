//
//  AuthManager.swift
//  AuthFirebaseExample
//
//  Created by David Molano on 2025-10-27.
//

import Combine  // Observable Pattern // Donde los componentes estaran notificados si alguna data o variable cambia en la app
// Como un state en React
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import Foundation

class AuthManager: ObservableObject {

    @Published var user: User?  // Lo mismo que FirebaseAuth.user? // Este user es para mantener el user durante toda la app
    @Published var twitterUser: TwitterUser?  // Este user es para traer toda la informacion de la db
    private let db = Firestore.firestore()

    init() {
        self.user = Auth.auth().currentUser  // Guardara el usuario para tenerlo presente en toda la app
        if let currentUser = self.user {

        }
    }

    // Fetch User Data

    private func fetchTwitterUserData(
        completion: @escaping (Result<TwitterUser?, Error>) -> Void
    ) {

        guard let uuid = Auth.auth().currentUser?.uid else {
            DispatchQueue.main.async {
                self.twitterUser = nil
            }
            completion(.success(nil))
            return
        }

        db.collection("users").document(uuid).getDocument { snapshot, error in
            if let error = error {
                print("Error fetching user data: \(error)")
                return
            }

            do {
                let twitteruser = try snapshot?.data(as: TwitterUser.self)
                DispatchQueue.main.async {
                    self.twitterUser = twitteruser
                }
                completion(.success(twitteruser))
            } catch {
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
    }

    // Register Method

    func register(
        email: String,
        password: String,
        fullname: String,
        username: String,
        bio: String,
        profileImage: UIImage? = nil,
        completion: @escaping (Result<User, Error>) -> Void
    ) {

        Auth.auth().createUser(withEmail: email, password: password) {
            (result, error) in
            if let error = error {
                completion(.failure(error))
                return
            } else if let user = result?.user {
                self.user = user
                completion(.success(user))
            }
        }
    }

    // Login Method

    func login(
        email: String,
        password: String,
        completion: @escaping (Result<User, Error>) -> Void
    ) {
        Auth.auth().signIn(withEmail: email, password: password) {
            (result, error) in

            if let error = error {
                completion(.failure(error))
                return
            } else if let user = result?.user {
                self.user = user
                completion(.success(user))
            }
        }
    }

    // SignOut Method

    func signOut(completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try Auth.auth().signOut()
            self.user = nil
            completion(.success(()))
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError)")
            completion(.failure(signOutError))
        }
    }

}
