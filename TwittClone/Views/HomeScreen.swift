//
//  HomeScreen.swift
//  TwittClone
//
//  Created by David Molano on 2025-11-05.
//

import SwiftUI

struct HomeScreen: View {

    @StateObject private var tweetManager = TweetManager()
    @State private var tweets: [TweetModel] = []

    var body: some View {
        ScrollView {

            VStack {
                Rectangle().fill(.primary).frame(height: 2)

                // Header
                Text("Your Feed")
                    .font(.largeTitle)
                    .foregroundColor(.primary)
                    .fontWeight(.bold)

                Rectangle().fill(.primary).frame(height: 2)
            }

            Spacer(minLength: 20)

            VStack(spacing: 16) {
                ForEach(tweets) { tweet in
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
        .onAppear {
            tweetManager.fetchTweets { result in
                switch result {
                case .success(let fetchedTweets):
                    self.tweets = fetchedTweets
                case .failure(let error):
                    print(
                        "Error fetching tweets: \(error.localizedDescription)"
                    )
                }
            }
        }
    }
}

#Preview {
    HomeScreen()
}
