//
//  TweetCardWithoutImageView.swift
//  TwittClone
//
//  Created by David Molano on 2025-11-13.
//

import FirebaseFirestore
import SDWebImageSwiftUI
import SwiftUI

struct TweetCardWithoutImageView: View {
    let tweet: TweetModel
    @State private var userProfileImage: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {

            HStack(spacing: 12) {
                // Profile Picture
                WebImage(url: URL(string: userProfileImage ?? ""))
                    .resizable()
                    .indicator(.activity)
                    .transition(.fade(duration: 0.25))
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                    .onAppear {
                        loadUserData()
                    }

                // Username
                Text(tweet.username)
                    .font(.headline)
                    .foregroundColor(.primary)

                Spacer()
            }

            // Tweet Content
            Text(tweet.content)
                .font(.body)
                .foregroundColor(.primary)

            // Date Posted
            Text(
                tweet.timestamp.formatted(date: .abbreviated, time: .shortened)
            )
            .font(.caption)
            .foregroundColor(.gray)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.primary, lineWidth: 2)
        )
        .shadow(radius: 2)
    }
    private func loadUserData() {
        let db = Firestore.firestore()
        db.collection("users").document(tweet.userId).getDocument {
            snapshot,
            error in
            if let user = try? snapshot?.data(as: TwitterUser.self) {
                self.userProfileImage = user.profileImageURL
            }
        }
    }
}
#Preview {
    TweetCardWithoutImageView(
        tweet: TweetModel(
            id: "1",
            userId: "123",
            username: "previewUser",
            content: "Tweet sin imagen.",
            timestamp: Date()
        )
    )
}
