//
//  AuthModel.swift
//  Mood
//
//  Created by Owner on 11/16/24.
//

import Foundation
import FirebaseAuth

class AuthModel: ObservableObject {
    @Published var isUserAuthenticated = false
    @Published var errorMessage: String?
    @Published var isEmailVerified = false
    
    func registerUser(email: String, password: String) {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Email and password cannot be empty."
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
            } else {
                self?.sendEmailVerification()
            }
        }
    }
    
    func signInUser(email: String, password: String) {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Email and password cannot be empty."
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                if error.localizedDescription.contains("expired") {
                    self?.errorMessage = "Your session has expired. Please log in again."
                    try? Auth.auth().signOut()
                } else {
                    self?.errorMessage = error.localizedDescription
                }
            } else {
                self?.checkEmailVerificationStatus()
            }
        }
    }
    
    private func checkEmailVerificationStatus() {
        if let user = Auth.auth().currentUser {
            if user.isEmailVerified {
                isUserAuthenticated = true
                isEmailVerified = true
            } else {
                errorMessage = "Please verify your email before signing in."
                isEmailVerified = false
            }
        }
    }
    
    func sendEmailVerification() {
        if let user = Auth.auth().currentUser {
            user.sendEmailVerification { [weak self] error in
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                } else {
                    self?.errorMessage = "Verification email sent. Please check your inbox."
                }
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            isUserAuthenticated = false
            isEmailVerified = false
        } catch let signOutError {
            errorMessage = signOutError.localizedDescription
        }
    }
}


