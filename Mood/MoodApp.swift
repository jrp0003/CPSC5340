//
//  MoodApp.swift
//  Mood
//
//  Created by Owner on 11/16/24.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        Auth.auth().settings?.isAppVerificationDisabledForTesting = false
        return true
    }
}

@main
struct MoodApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var authModel = AuthModel()

    var body: some Scene {
        WindowGroup {
            NavigationView {
                if authModel.isUserAuthenticated {
                    MoodView(viewModel: MoodViewModel())
                } else {
                    AuthView(viewModel: authModel)                }
            }
        }
    }
}


