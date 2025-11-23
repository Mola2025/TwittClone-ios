//
//  TwittCloneApp.swift
//  TwittClone
//
//  Created by David Molano on 2025-10-30.
//

import FirebaseCore  // Necesito añadir las librerias primero en la config del proyecto en frameworks las que necesite (Auth,Store, Etc)
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication
            .LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()

        return true
    }
}

@main
struct TwittCloneApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var authManager = AuthManager()  // Initialize Object AuthManager
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(authManager)
        }
    }
}
