//
//  AuthView.swift
//  Mood
//
//  Created by Owner on 11/16/24.
//

import SwiftUI

struct AuthView: View {
    @StateObject var viewModel: AuthModel
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isRegistering = false 
    
    var body: some View {
        VStack(spacing: 20) {
            Text(isRegistering ? "Register" : "Sign In")
                .font(.largeTitle)
                .bold()
            
            TextField("Email", text: $email)
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
            
            SecureField("Password", text: $password)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
            
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: {
                if isRegistering {
                    viewModel.registerUser(email: email, password: password)
                } else {
                    viewModel.signInUser(email: email, password: password)
                }
            }) {
                Text(isRegistering ? "Register" : "Sign In")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            
            Button(action: {
                isRegistering.toggle()
            }) {
                Text(isRegistering ? "Already have an account? Sign In" : "Don't have an account? Register")
                    .foregroundColor(.blue)
            }
            
            Spacer()
        }
        .padding()
        .alert(isPresented: .constant(viewModel.isUserAuthenticated)) {
            Alert(title: Text("Success"), message: Text("You are now signed in!"), dismissButton: .default(Text("OK")))
        }
    }
}




