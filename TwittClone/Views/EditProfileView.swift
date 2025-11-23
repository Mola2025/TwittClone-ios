//
//  EditProfileView.swift
//  TwittClone
//
//  Created by David Molano on 2025-11-18.
//

import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import PhotosUI
import SDWebImageSwiftUI
import SwiftUI

struct EditProfileView: View {
    @EnvironmentObject var authManager: AuthManager
    @StateObject private var tweetManager = TweetManager()

    // This variable is for handling te return to the previous page after making an update to the profile or making an update into the DB
    @Environment(\.dismiss) var dismiss

    @State private var fullname: String = ""
    @State private var username: String = ""
    @State private var bio: String = ""

    @State private var currentUser: TwitterUser? = nil
    @State private var userTweets: [TweetModel] = []
    @State private var errorMessage: String? = nil

    // For the image
    @State var data: UIImage?
    @State var selectedItem: [PhotosPickerItem] = []

    // For the Toast
    @State private var showToast = false
    @State private var toastMessage = ""
    @State private var toastIsError = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // Header
                VStack(alignment: .center) {
                    if let currentUser = currentUser {
                        if let url = currentUser.profileImageURL {
                            WebImage(
                                url: URL(string: url ?? "")
                            )
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                        } else {
                            Image(systemName: "person.circle.fill.dark")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 120)
                                .clipShape(Circle())
                                .foregroundColor(.gray)
                        }

                        Text(currentUser.email)
                            .foregroundColor(.gray)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.top)

                Divider()

                VStack {
                    // Preview of selected image
                    if let image = data {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 250)
                            .cornerRadius(12)
                            .padding(.horizontal)
                            .clipShape(Circle())
                    }

                    Text("New Profile Image")
                        .font(Font.headline.bold())
                        .padding(.horizontal, 150)

                    // Image
                    PhotosPicker(
                        selection: $selectedItem,
                        maxSelectionCount: 1,
                        matching: .images
                    ) {
                        HStack {
                            Image(systemName: "photo.on.rectangle.angled")
                            Text("Select a New Profile Image")
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
                                if let data = data,
                                    let uiImage = UIImage(data: data)
                                {
                                    self.data = uiImage
                                }
                            case .failure(let failure):
                                print("Error: \(failure.localizedDescription)")
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                Divider()

                // Form Fields to change profile info

                VStack(alignment: .leading, spacing: 20) {

                    Group {
                        Text("Full Name")
                            .foregroundColor(.gray)
                        TextField("Full Name", text: $fullname)
                            .padding()
                            .background(Color.gray.opacity(0.15))
                            .cornerRadius(10)
                    }

                    Group {
                        Text("Username")
                            .foregroundColor(.gray)
                        TextField("Username", text: $username)
                            .autocapitalization(.none)
                            .padding()
                            .background(Color.gray.opacity(0.15))
                            .cornerRadius(10)
                    }

                    Group {
                        Text("Bio")
                            .foregroundColor(.gray)
                        TextField("Bio", text: $bio, axis: .vertical)
                            .lineLimit(3...6)
                            .padding()
                            .background(Color.gray.opacity(0.15))
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal)

                // Error message
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                }

                // Buttons

                HStack(spacing: 12) {

                    Button {
                        updateProfile()
                    } label: {
                        Text("Update Profile")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(30)
                    }

                    NavigationLink(destination: TabScreen()) {
                        Text("Cancel")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(30)
                }
                .padding(.horizontal)
            }
            // Toast
            VStack {
                Spacer()
                if showToast {
                    ToastView(message: toastMessage, isError: toastIsError)
                        .transition(
                            .move(edge: .bottom).combined(with: .opacity)
                        )
                        .animation(.spring(), value: showToast)
                        .padding(.bottom, 30)
                }
            }
        }.onAppear {
            loadUser()
        }
    }

    private func loadUser() {
        guard let uid = authManager.user?.uid else { return }

        Firestore.firestore().collection("users").document(uid).getDocument {
            snapshot,
            error in
            if let error = error {
                self.showError("Error loading profile: \(error.localizedDescription)")
                return
            }

            do {
                if let currentUser = try snapshot?.data(as: TwitterUser.self) {
                    self.currentUser = currentUser

                    // Fetch the current user info into the textboxes
                    self.fullname = currentUser.fullname ?? ""
                    self.username = currentUser.username ?? ""
                    self.bio = currentUser.bio ?? ""
                }
            } catch {
                self.showError(
                    "Error decoding profile")
            }
        }
    }

    private func updateProfile() {
        guard let uid = authManager.user?.uid else { return }

        var updates: [String: Any] = [:]

        // Only update if user write something in the text boxes
        if !fullname.trimmingCharacters(in: .whitespaces).isEmpty {
            updates["fullname"] = fullname
        }

        if !username.trimmingCharacters(in: .whitespaces).isEmpty {
            updates["username"] = username
        }

        if !bio.trimmingCharacters(in: .whitespaces).isEmpty {
            updates["bio"] = bio
        }

        // If there is no image, means keep the same
        if data == nil {
            saveUpdates(uid: uid, updates: updates)
            return
        }

        // If there is a new image

        if let newImage = data {
            uploadProfileImage(image: newImage) { url in
                if let url = url {
                    updates["profileImageURL"] = url
                }

                self.saveUpdates(uid: uid, updates: updates)

            }
        } else {
            saveUpdates(uid: uid, updates: updates)
        }
    }

    private func saveUpdates(uid: String, updates: [String: Any]) {
        Firestore.firestore().collection("users").document(uid).updateData(
            updates
        ) { error in
            if let error = error {
                self.showError( "Error updating profile: \(error.localizedDescription)")
            } else {
                self.showSuccess("Profile Updated Successfully")
                // Update the username and profile picture in all tweets
                self.updateUserTweets(uid: uid, newUsername: self.username)

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    dismiss()
                }
            }
        }
    }

    private func updateUserTweets(uid: String, newUsername: String) {
        let db = Firestore.firestore()

        // Update the username and profile picture in all tweets
        db.collection("tweets")
            .whereField("userId", isEqualTo: uid)
            .getDocuments { snapshot, error in
                if let error = error {
                    self.showError(
                        "Error fetching user tweets: \(error.localizedDescription)"
                    )
                    return
                }

                guard let documents = snapshot?.documents else { return }

                let batch = db.batch()

                for document in documents {
                    let tweetRef = db.collection("tweets").document(
                        document.documentID
                    )
                    batch.updateData(
                        ["username": newUsername],
                        forDocument: tweetRef
                    )
                }

                batch.commit { error in
                    if let error = error {
                        self.showError(
                            "Error updating tweets: \(error.localizedDescription)"
                        )
                    } else {
                        print("Successfully updated \(documents.count) tweets")
                    }
                }
            }
    }

    private func uploadProfileImage(
        image: UIImage,
        completion: @escaping (String?) -> Void
    ) {

        guard let uid = authManager.user?.uid else { return }

        let storageRef = Storage.storage().reference()
            .child("profile_images/\(uid).jpg")

        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            completion(nil)
            return
        }

        storageRef.putData(imageData, metadata: nil) { _, error in
            if let error = error {
                self.showError("Upload failed: \(error.localizedDescription)")
                completion(nil)
                return
            }

            storageRef.downloadURL { url, error in
                if let error = error {
                    print("URL error: \(error.localizedDescription)")
                    completion(nil)
                } else {
                    completion(url?.absoluteString)
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
    EditProfileView().environmentObject(AuthManager())
}
