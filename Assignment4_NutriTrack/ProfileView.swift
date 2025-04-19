//
//  ProfileView.swift
//  Assignment4_NutriTrack
//
//  Created by user on 2025-04-18.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var user: User? = Auth.auth().currentUser
    @State private var errorMessage: String?

    var body: some View {
        NavigationView {
            VStack {
                Spacer().frame(height: 70)

                VStack(spacing: 20) {
                    if let user = user {
                        Text("Welcome")
                            .font(.title)
                            .fontWeight(.bold)

                        Text(user.email ?? "No email")
                            .font(.title3)
                            .fontWeight(.semibold)

                        Button(action: signOut) {
                            Text("Sign Out")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.red.opacity(0.8))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }

                    } else {
                        Text("Welcome")
                            .font(.title)
                            .fontWeight(.bold)

                        TextField("Email", text: $email)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .autocapitalization(.none)

                        SecureField("Password", text: $password)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)

                        Button(action: signIn) {
                            Text("Login")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }

                        Button(action: register) {
                            Text("Register")
                                .font(.subheadline)
                                .foregroundColor(.blue)
                        }

                        if let errorMessage = errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .font(.caption)
                        }
                    }
                }
                .padding(.horizontal)
                .frame(maxWidth: 320)

                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
            .navigationTitle("Profile")
            .onAppear {
                user = Auth.auth().currentUser
            }
        }
    }

    func signIn() {
        errorMessage = nil
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                errorMessage = error.localizedDescription
            } else {
                user = result?.user
            }
        }
    }

    func register() {
        errorMessage = nil
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                errorMessage = error.localizedDescription
            } else {
                user = result?.user
            }
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            user = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
