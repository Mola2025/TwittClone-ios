//
//  ProfileView.swift
//  TwittClone
//
//  Created by David Molano on 2025-11-05.
//

import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import SDWebImageSwiftUI
import SwiftUI

struct ProfileView: View {

    @EnvironmentObject var authManager: AuthManager
    @StateObject private var tweetManager = TweetManager()

    @State private var currentUser: TwitterUser? = nil
    @State private var userTweets: [TweetModel] = []
    @State private var errorMessage: String? = nil

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // Header
                if let user = currentUser {
                    VStack(spacing: 20) {
                        HStack(alignment: .top, spacing: 16) {

                            WebImage(
                                url: URL(string: user.profileImageURL ?? "")
                            )
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())

                            VStack(alignment: .leading, spacing: 8) {
                                Text(user.fullname)
                                    .font(.system(size: 26))
                                    .bold()
                                Text(user.username)
                                    .font(.system(size: 16))
                                    .foregroundColor(.gray)

                                if let bio = user.bio, !bio.isEmpty {
                                    Text(bio)
                                        .font(.system(size: 14))
                                        .foregroundColor(.primary)
                                        .padding(.top, 4)
                                }

                                HStack(spacing: 16) {
                                    HStack {
                                        Text("\(user.followers)").bold()
                                        Text("Followers").foregroundColor(.gray)
                                    }
                                    HStack {
                                        Text("\(user.following)").bold()
                                        Text("Following").foregroundColor(.gray)
                                    }
                                }
                                .font(.system(size: 14))
                                .padding(.top, 4)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.top, 4)

                    Divider()
                }

                // Buttons

                HStack(spacing: 12) {

                    NavigationLink(destination: EditProfileView()) {
                        Text("Edit Profile")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(30)

                    Button(role: .destructive) {
                        singOut()
                    } label: {
                        Text("Sign Out")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(30)
                    }
                }
                .padding(.horizontal)

                Divider()

                // User Own Tweets Posted

                VStack(alignment: .leading, spacing: 16) {
                    Text("My Tweets").font(.title).bold().padding(.horizontal)
                    ForEach(userTweets) { tweet in
                        if let imageURL = tweet.imageURL, !imageURL.isEmpty {
                            TweetCardWithImageView(
                                tweet: tweet
                            )
                        } else {
                            TweetCardWithoutImageView(
                                tweet: tweet
                            )
                        }
                    }
                }
                .padding(.horizontal)

            }
        }.onAppear {
            loadUser()
            loadUserTweets()
        }
    }

    private func loadUser() {
        guard let uid = authManager.user?.uid else { return }

        Firestore.firestore().collection("users").document(uid).getDocument {
            snapshot,
            error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                return
            }

            do {
                self.currentUser = try snapshot?.data(as: TwitterUser.self)
            } catch {
                self.errorMessage =
                    "Error loading profile: \(error.localizedDescription)"
            }
        }
    }

    private func loadUserTweets() {
        tweetManager.fetchTweets { result in
            switch result {
            case .success(let tweets):
                guard let uid = Auth.auth().currentUser?.uid else { return }
                self.userTweets = tweets.filter { $0.userId == uid }
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }

    private func singOut() {
        authManager.signOut { result in
            switch result {
            case .success():
                self.errorMessage = nil
                print("Successfully Logout")

            case .failure(let error):
                self.errorMessage = error.localizedDescription
                print("Sign Out Error: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    ProfileView().environmentObject(AuthManager())
}
