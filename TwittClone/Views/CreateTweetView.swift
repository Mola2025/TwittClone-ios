//
//  CreateTweetView.swift
//  TwittClone
//
//  Created by David Molano on 2025-11-08.
//

import PhotosUI
import SwiftUI

struct CreateTweetView: View {
    @StateObject private var tweetManager = TweetManager()
    @State private var tweetText = ""
    @State private var errorMessage: String? = nil
    @State private var isPosting = false
    @State private var NavigateToHome = false

    // For the image
    @State var data: UIImage?
    @State var selectedItem: [PhotosPickerItem] = []

    // For the Toast
    @State private var showToast = false
    @State private var toastMessage = ""
    @State private var toastIsError = false

    var body: some View {
        ZStack{
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
                PhotosPicker(
                    selection: $selectedItem,
                    maxSelectionCount: 1,
                    matching: .images
                ) {
                    HStack {
                        Image(systemName: "photo.on.rectangle.angled")
                        Text("Attach image")
                    }
                    .foregroundColor(.black)
                    .padding(8)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                }
                .onChange(of: selectedItem) { newValue in
                    guard let item = newValue.first else { return }
                    item.loadTransferable(type: Data.self) { result in
                        switch result {
                        case .success(let data):
                            if let data = data, let uiImage = UIImage(data: data) {
                                self.data = uiImage
                            }
                        case .failure(let failure):
                            print("Error: \(failure.localizedDescription)")
                        }
                    }
                }
                .padding(.horizontal)
                
                // Preview of selected image
                if let image = data {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 250)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
                
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
                    .background(
                        disablePostButton ? Color.blue.opacity(0.3) : Color.blue
                    )
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .disabled(disablePostButton)
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            // Toast
            VStack {
                Spacer()
                if showToast {
                    ToastView(message: toastMessage, isError: toastIsError)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .animation(.spring(), value: showToast)
                        .padding(.bottom, 30)
                }
            }
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
        guard !tweetText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        else {
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

        tweetManager.createTweet(content: tweetText, image: data) { result in
            DispatchQueue.main.async {
                isPosting = false

                switch result {
                case .success:
                    showSuccess("Tweet Published")
                    data = nil
                    tweetText = ""

                case .failure(let error):
                    showError("Error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // Toast Functions

        private func showSuccess(_ message: String) {
            toastMessage = message
            toastIsError = false
            showToast = true

            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                showToast = false
            }
        }

        private func showError(_ message: String) {
            toastMessage = message
            toastIsError = true
            showToast = true

            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                showToast = false
            }
        }

}

#Preview {
    CreateTweetView()
}
