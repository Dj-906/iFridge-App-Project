//
//  ContentView.swift
//  iFridge
//
//  Created by qunliu on 1/22/25.
//

import SwiftUI
import FirebaseAuth
import FirebaseCore

struct LoginView: View {
    
    @Binding var isLoggedIn: Bool
    
    @State var email = ""
    @State var password = ""
    @State var loginStatusMessage = ""
    
    //init() { FirebaseApp.configure() }
    
    var body: some View {
        NavigationView{
            ScrollView{
                VStack(spacing: 64) {
                    VStack(spacing: 8){
                        Image("fridge_main")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .padding()
                        Text("iFridge")
                            .font(.largeTitle)
                    }
                    
                    VStack(spacing: 16){
                        HStack {
                            Text("Login your account")
                                .font(.title3)
                                .foregroundColor(.black)
                            Spacer()
                        }
                        
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.none)
                            .padding(.all, 12.0)
                            .background(Color(.secondaryLabel).opacity(0.12))
                            .cornerRadius(16)
                        
                        SecureField("Password", text: $password)
                            .padding(.all, 12.0)
                            .background(Color(.secondaryLabel).opacity(0.12))
                            .cornerRadius(16)
                        
                        Button{
                            loginUser()
                        } label: {
                            HStack {
                                Spacer()
                                Text("Login")
                                    .foregroundColor(.white)
                                    .padding(.vertical, 12)
                                Spacer()
                            }
                            .background(Color.black)
                            .cornerRadius(32)
                        }
                        Text(self.loginStatusMessage)
                            .foregroundColor(.black)
                        
                    }
                    
                    
                    
                    
                    VStack(spacing: 8){
                        Text("Don't have an account?")
                            .foregroundColor(.gray)
                        
                        NavigationLink(destination: RegisterView()) {
                            Text("Create Account")
                                .foregroundColor(.blue)
                                .font(.headline)
                            
                        }
                    }
                }
                .padding(32)
            }
        }
    }
    
    private func loginUser() {
        FirebaseManager.shared.auth.signIn(withEmail: email, password: password) { result, err in
            if let err = err {
                print("Error logging in:", err)
                loginStatusMessage = "Failed to login user"
                return
            }
            
            guard let user = result?.user else { return }
            loginStatusMessage = "Login successful: \(user.uid)"
            isLoggedIn = true
        }
    }
}

#Preview {
    LoginView(isLoggedIn: .constant(false))
    
}
