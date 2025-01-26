//
//  RegisterView.swift
//  iFridge
//
//  Created by 刘群 on 1/25/25.
//

import SwiftUI
import FirebaseAuth
import FirebaseCore

struct RegisterView: View {
    @State var email = ""
    @State var password = ""
    @State var registerStatusMessage = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
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
                    
                    VStack(alignment: .leading, spacing: 16){
                        HStack {
                            Text("Create your account")
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
                            createNewAccount()
                        } label: {
                            HStack {
                                Spacer()
                                Text("Create Account")
                                    .foregroundColor(.white)
                                    .padding(.vertical, 12)
                                Spacer()
                            }
                            .background(Color.black)
                            .cornerRadius(32)
                        }
                        
                        Text(self.registerStatusMessage)
                            .foregroundColor(.black)
                        
                    }
                }
                .padding(32)
            }
        }
    }
    
        private func createNewAccount() {
            Auth.auth().createUser(withEmail: email, password: password) { result, err in
                if let err = err {
                    print("Error creating user:", err)
                    self.registerStatusMessage = "Failed to create user: \(err.localizedDescription)"
                    return
                }
                
                print("Sucessfully created a new user: \(result?.user.uid ?? "")")
                self.registerStatusMessage = "User created successfully"
            }
        }
    }


#Preview {
    RegisterView()
}
