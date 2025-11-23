//
//  SearchUsersView.swift
//  TwittClone
//
//  Created by David Molano on 2025-11-08.
//

import FirebaseAuth
import FirebaseFirestore
import SDWebImageSwiftUI
import SwiftUI

struct SearchUsersView: View {

    @EnvironmentObject var authManager: AuthManager

    @State private var searchText: String = ""
    @State private var users: [TwitterUser] = []
    @State private var isLoading: Bool = false

    private let db = Firestore.firestore()

    var body: some View {
        NavigationStack{
            VStack {
                if isLoading {
                    ProgressView().padding()
                }
                
                List {
                    ForEach(users) {
                        user in
                        UserSeachCardView(
                            user: user,
                            currentUser: authManager.twitterUser,
                            onFollowToogle: { toogleFollow(user) }
                        )
                    }
                }.listStyle(.plain)
            }
            .navigationTitle("Search Users")
            .searchable(text: $searchText)
            .onChange(of: searchText) {
                text in
                if text.count >= 2 {
                    SearchUsers()
                } else {
                    users = []
                }
            }
        }
    }

    private func SearchUsers() {
        guard !searchText.isEmpty else { return }
        guard let myId = authManager.user?.uid else { return }

        isLoading = true

        db.collection("users")
            .whereField(
                "username",
                isGreaterThanOrEqualTo: searchText.lowercased()
            )
            .whereField(
                "username",
                isLessThanOrEqualTo: searchText.lowercased() + "\u{f8ff}"
            )
            .getDocuments { snapshot, error in

                self.isLoading = false

                if let error = error {
                    print(
                        "Error searching users: \(error.localizedDescription)"
                    )
                    return
                }

                let found =
                    snapshot?.documents.compactMap {
                        try? $0.data(as: TwitterUser.self)
                    } ?? []

                self.users = found.filter { $0.id != myId }
            }
    }

    private func toogleFollow(_ target: TwitterUser) {
        guard var current = authManager.twitterUser else { return }
        guard var targetId = target.id else { return }
        guard var currentId = current.id else { return }

        let currentRef = db.collection("users").document(currentId)
        let targetRef = db.collection("users").document(targetId)

        let isFollowing = current.followingUserIds?.contains(targetId) ?? false

        db.runTransaction({ (transaction, errorPointer) -> Any? in
            do {
                let targetSnapshot = try transaction.getDocument(targetRef)
                let currentSnapshot = try transaction.getDocument(currentRef)

                var targetUser = try targetSnapshot.data(as: TwitterUser.self)
                var currentUser = try currentSnapshot.data(as: TwitterUser.self)

                if isFollowing {
                    // Show Unfollow Option
                    targetUser.followers -= 1
                    currentUser.following -= 1
                    currentUser.followingUserIds?.removeAll(where: {
                        $0 == targetId
                    })
                } else {
                    // Follow Option

                    targetUser.followers += 1
                    currentUser.following += 1
                    if currentUser.followingUserIds == nil {
                        currentUser.followingUserIds = []
                    }
                    currentUser.followingUserIds?
                        .append(targetId)
                }

                try transaction.setData(
                    from: targetUser,
                    forDocument: targetRef
                )
                try transaction.setData(
                    from: currentUser,
                    forDocument: currentRef
                )

                return nil
            } catch {
                errorPointer?.pointee = error as NSError
                return nil
            }
        }) { result, error in

            if let error = error {
                print("An error occurred Follow/Unfollow Failed: \(error)")
                return
            }

            // Update current user info of following / followers

            if isFollowing {
                current.following -= 1
                current.followingUserIds?.removeAll(where: { $0 == targetId })
            } else {
                current.following += 1
                current.followingUserIds?
                    .append(targetId)
            }
            
            // Bring the updated user from the db

            Firestore.firestore().collection("users").document(currentId).getDocument { snapshot, error in
                if let snapshot = snapshot,
                   let updatedUser = try? snapshot.data(as: TwitterUser.self) {
                    DispatchQueue.main.async {
                        authManager.twitterUser = updatedUser
                    }
                }
            }

            // Reload the list

            SearchUsers()
        }
    }
}

#Preview {
    NavigationStack {
            SearchUsersView()
                .environmentObject(AuthManager())
        }
}
