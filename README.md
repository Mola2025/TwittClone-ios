[README.md](https://github.com/user-attachments/files/23733816/README.md)
# Twitter Clone Swift App

A fully functional Twitter‑like social media application built in **Swift + SwiftUI** with **Firebase Authentication, Firestore, and Storage**.

This project replicates the core features of Twitter: creating tweets (with or without images), displaying a live timeline, authenticating users, editing profiles, and managing followers.

---

## Description

This project is designed as a complete learning‑oriented example that demonstrates how to build a clone app of twitter using **SwiftUI** and **Firebase**.

It follows clean architecture principles and real‑time database updates. The main functionalities include:

### User Authentication

- Email/password registration
- Login/logout
- Firebase Auth session persistence

### User Profiles

- Editable profile (fullname, username, bio, profile picture)
- Automatic loading of user information
- Profile image stored in Firebase Storage

### Tweet System

- Create tweets with text
- Upload images for tweets
- Real‑time timeline using Firestore listeners
- Display tweets with user info and profile picture

### Firestore Integration

- User information stored in a `users` collection
- Tweets stored in a `tweets` collection
- All using Codable models and automatic Firestore decoding

This project is a fully functional base for anyone wanting to understand how to build scalable social apps with SwiftUI and Firebase.

---

## Project Architecture Diagrams

![alt text](TwittCloneClassDiagram.jpg)

![alt text](TwittCloneFlowChart.jpg)

---

## Installation Instructions

Follow these steps to run the project on your machine. The process is similar to the workflow shown in the YouTube example.

### 1. Clone the Repository

```
git clone <your-repo-url>
cd TwittClone
```

### 2. Open the Project in Xcode

- Double‑click on TwittClone.xcodeproj

### 3. Install Dependencies

This project uses Firebase via Swift Package Manager.

In Xcode:

1. Go to File > Add Packages
2. Add:

   - `https://github.com/firebase/firebase-ios-sdk`
   - `https://github.com/SDWebImage/SDWebImage`
   - `https://github.com/SDWebImage/SDWebImageSwiftUI`

3. Select these products:

   - FirebaseAuth
   - FirebaseFirestore
   - FirebaseStorage
   - FirebaseFirestoreSwift

   - SDWebImage
   - SDWebImageMapKit
   - SDWebImageSwiftUI

### 4. Configure Firebase

This step is essential.

1. Go to [https://console.firebase.google.com](https://console.firebase.google.com)
2. Create a new Firebase project
3. Add an **iOS App**
4. Enter your Bundle ID (e.g., `com.example.twittclone`)
5. Follow the steps from google page

### 5. Enable Firebase Services

Inside the Firebase console:

- Authentication → Enable **Email/Password**
- Firestore → Create database (**Start in test mode** for development)
- Storage → Enable

### 6. Build the Project

In Xcode:

- Product → Clean Build Folder
- Then Run the app on a simulator or device

Everything should now compile successfully.
