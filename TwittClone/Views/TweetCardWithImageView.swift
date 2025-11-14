//
//  TweetCardWithImageView.swift
//  TwittClone
//
//  Created by David Molano on 2025-11-13.
//

import SwiftUI
import SDWebImageSwiftUI

struct TweetCardWithImageView: View {
    let tweet: TweetModel
    let userProfileImage: String?
    
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
            
            // If there is an image in the tweet is here
            if let imageURL = tweet.imageURL, !imageURL.isEmpty {
                WebImage(url: URL(string: imageURL))
                    .resizable()
                    .indicator(.activity)
                    .transition(.fade(duration: 0.25))
                    .scaledToFit()
                    .cornerRadius(12)
            }
            
            // Date Posted
            Text(tweet.timestamp.formatted(date: .abbreviated, time: .shortened))
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
}

#Preview {
    TweetCardWithImageView(
        tweet: TweetModel(
            id: "1",
            userId: "123",
            username: "previewUser",
            content: "Tweet con imagen.",
            imageURL: "https://picsum.photos/300",
            timestamp: Date()
        ),
        userProfileImage: "https://picsum.photos/50"
    )
}


