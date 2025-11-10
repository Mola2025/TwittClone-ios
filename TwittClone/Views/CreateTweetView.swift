//
//  CreateTweetView.swift
//  TwittClone
//
//  Created by David Molano on 2025-11-08.
//

import SwiftUI

struct CreateTweetView: View {
    @StateObject private var tweetManager = TweetManager()
    @State private var tweetText = ""
    @State private var errorMessage: String? = nil
    @Environment(\.dismiss) var dismiss
    @State private var isPosting = false
    @State private var NavigateToHome = false
    
    var body: some View {
        VStack(spacing: 20) {
            
            // Header
            HStack {
                NavigationLink(
                    destination: TabScreen(),
                    isActive: $NavigateToHome
                ) {
                    EmptyView()
                }
                
                Button("Cancel") {
                    NavigateToHome = true
                }
                .foregroundColor(.blue)
                .frame(maxWidth: 80)
                .frame(maxHeight: 40)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                
                Spacer()
                
                Text("New Tweet")
                    .font(.headline)
                    .fontWeight(.bold)
                
                Spacer()
                Spacer()

            }
            .padding(.horizontal)
            .padding(.top)
            
            // Tweet Text
            VStack(alignment: .leading, spacing: 10) {
                
                TextEditor(text: $tweetText)
                    .frame(height: 150)
                    .padding(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                    .background(Color(.systemBackground))
                
//                if tweetText.isEmpty{
//                    Text("Write your tweet here...")
//                        .foregroundColor(.gray)
//                        .padding(.horizontal, 12)
//                        .padding(.vertical, 16)
//                }
                
                // Character count
                HStack {
                    Spacer()
                    Text("\(tweetText.count)/280")
                        .font(.caption)
                        .foregroundColor(tweetText.count > 280 ? .red : .gray)
                }
            }
            .padding(.horizontal)
            
            // Image
            HStack {
                Button(action: {
                    // Method Upload Image
                }) {
                    HStack {
                        Image(systemName: "photo")
                            .font(.title2)
                            .foregroundColor(.black)
                        Text("Attach image")
                            .foregroundColor(.black)
                    }
                    .padding(8)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                }
                
                Spacer()
            }
            .padding(.horizontal)
            
            // Error message
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.subheadline)
                    .padding(.horizontal)
            }
            
            Spacer()
            
            // Submit And Cancel buttons
            HStack(spacing: 20) {
                // Clear button
                Button("Clear") {
                    clearTweet()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.gray.opacity(0.2))
                .foregroundColor(.primary)
                .cornerRadius(10)
                .disabled(tweetText.isEmpty || isPosting)
                
                // Post tweet button
                Button("Create Tweet") {
                    postTweet()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(disablePostButton ? Color.blue.opacity(0.3) : Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .disabled(disablePostButton)
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
    }
    
    // Check if post button should be disabled
    private var disablePostButton: Bool {
        tweetText.isEmpty || tweetText.count > 280 || isPosting
    }
    
    private func clearTweet() {
        tweetText = ""
        errorMessage = nil
    }
    
    private func postTweet() {
        
        // Check if tweet is not empty
        guard !tweetText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorMessage = "Tweet cannot be empty"
            return
        }
        
        // Check character limit
        guard tweetText.count <= 280 else {
            errorMessage = "Tweet cannot be longer than 280 characters"
            return
        }
        
        isPosting = true
        errorMessage = nil
        
        tweetManager.createTweet(content: tweetText) { result in
            DispatchQueue.main.async {
                isPosting = false
                
                switch result {
                case .success(let message):
                    print("Tweet Published: \(message)")
                    
                    
                case .failure(let error):
                    errorMessage = "Error: \(error.localizedDescription)"
                    print("Error in posting twwet: \(error.localizedDescription)")
                }
            }
        }
    }
}

#Preview {
    CreateTweetView()
}
