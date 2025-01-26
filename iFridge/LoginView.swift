//
//  ContentView.swift
//  iFridge
//
//  Created by qunliu on 1/22/25.
//

import SwiftUI
import FirebaseAuth
import FirebaseCore

class FirebaseManager: NSObject {
    let auth: Auth
    
    static let shared = FirebaseManager()
    
    override init() {
        FirebaseApp.configure()
        
        self.auth = Auth.auth()
        
        super.init()
    }
}

struct LoginView: View {
    
    @State var isLoginMode = false
    @State var email = ""
    @State var password = ""
    @State var isLoggedIn = false
    
    init() {
        
    }
    
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack(spacing: 16) {
                    Picker(selection: $isLoginMode, label: Text("Picker here")){
                        Text("Login")
                            .tag(true)
                        Text("Create Account")
                            .tag(false)
                    }.pickerStyle(SegmentedPickerStyle())
                    
                    Button{
                        
                    }label: {
                        Image(systemName: "person.fill")
                            .font(.system(size: 64))
                            .padding()
                    }
                    
                    Group {
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.none)
                        SecureField("Password", text: $password)
                    }
                    .padding(.all, 12.0)
                    .background(Color(.secondaryLabel).opacity(0.12))
                    .cornerRadius(16)
                    
                    
                    Button{
                        handleAction()
                    } label: {
                        HStack {
                            Spacer()
                            Text(isLoginMode ? "Login" :"Create Account")
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
                .padding(32)
            }
            .navigationTitle(isLoginMode ? "Login" : "Create Account")
        }
    }
    
    private func handleAction() {
        if isLoginMode {
            print("should log into Firebase with existing credentials")
            loginUser()
            
        } else {
            createNewAccount()
//            print ("should create a new user account in Firebase")
        }
    }
    
    private func loginUser() {
        FirebaseManager.shared.auth.signIn(withEmail: email, password: password) { result, err in
            if let err = err {
                print("Error logging in:", err)
                self.loginStatusMessage = "Failed to login user"
                return
            }
            
            print("Sucessfully logged in: \(result?.user.uid ?? "")")
            
            self.loginStatusMessage = "Login successful"
            self.isLoggedIn = true
        }
    }
    
    @State var loginStatusMessage = " "
    
    private func createNewAccount() {
        FirebaseManager.shared.auth.createUser(withEmail: email, password: password) { result, err in
            if let err = err {
                print("Error creating user:", err)
                self.loginStatusMessage = err.localizedDescription
                return
            }
            
            print("Sucessfully created a new user: \(result?.user.uid ?? "")")
            
            self.loginStatusMessage = "User created successfully"
        }
    }
}

#Preview {
    LoginView()
}


