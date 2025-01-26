//
//  ProfileView.swift
//  iFridge
//
//  Created by 刘群 on 1/25/25.
//

import SwiftUI
import FirebaseStorage
import FirebaseAuth

class FirebaseManager: NSObject {
    static let shared = FirebaseManager ()
    let auth: Auth
    let storage: Storage
    
    override init() {
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        
        super.init()
    }
}

struct ProfileView: View {
    
    @State private var currentImage: UIImage?
    
    @State private var newSelectedImage: UIImage?
    
    @State private var statusMessage: String = ""
    
    @State private var shouldShowImagePicker: Bool = false
    
    @State private var shouldGoToLogin = false
    
    
    var body: some View {
        NavigationView {
            
            VStack(spacing: 16) {
                
                //show user's email
                if let user = FirebaseManager.shared.auth.currentUser {
                    Text("Username: \(user.email ?? "No Email Provided")")
                        .font(.headline)
                } else {
                    Text("No user logged in")
                        .font(.headline)
                }
                
                //
                let displayImage = newSelectedImage ?? currentImage
                if let image = displayImage{
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 128, height: 128)
                        .scaledToFill()
                        .cornerRadius(64)
                        .overlay(RoundedRectangle(cornerRadius: 64).stroke(Color.black, lineWidth: 3))
                } else {
                    Image(systemName: "person.fill")
                        .font(.system(size: 64))
                        .padding()
                        .foregroundColor(.black)
                        .overlay(RoundedRectangle(cornerRadius: 64).stroke(Color.black, lineWidth: 3))
                }
                
                Button {
                    shouldShowImagePicker.toggle()
                } label: {
                    Text("Select Image")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(16)
                }
                
                if newSelectedImage != nil {
                    HStack{
                        Button("Cancel") {
                            newSelectedImage = nil
                            statusMessage = "Cancelld new image selection"
                        }
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(32)
                        
                        Spacer()
                        
                        Button("Upload") {
                            persistImageToStorage()
                        }
                        .padding()
                        .background(Color.black.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(32)
                    }
                    .padding(.horizontal)
                }
                Text(statusMessage)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding()
                
                Spacer()
                
                Button {
                    signOut()
                } label: {
                    Text("Sign Out")
                        .foregroundColor(.black)
                        .padding(32)
                        .frame(maxWidth: .infinity)
                        .background(.white)
                        .cornerRadius(32)
                }
                
                NavigationLink(destination: LoginView(isLoggedIn: .constant(false)).navigationBarBackButtonHidden(true),
                               isActive: $shouldGoToLogin) {
                    EmptyView()
                    
                }
                .hidden()
            }
            .padding()
            .navigationTitle(Text("Profile"))
        }
        .onAppear {
            
            
        }
        .sheet(isPresented: $shouldShowImagePicker) {
            ImagePicker(image: $newSelectedImage)
        }
    }
    
    //upload new image to firebase
    private func persistImageToStorage() {
        guard let newImage = newSelectedImage else {
            return
        }
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            statusMessage = "No current user."
            return
        }
        
        let fileName = UUID().uuidString
        let ref = FirebaseManager.shared.storage.reference(withPath: "\(uid)/\(fileName)")
        
        guard let imageData = newImage.jpegData(compressionQuality: 0.5) else {
            statusMessage = "Failed to compress image."
            return
        }
        
        ref.putData(imageData, metadata: nil) {metadata, err in
            if let err = err {
                statusMessage = "Failed to push image to Storage: \(err)"
                return
            }
            
            ref.downloadURL { url, err in
                if let err = err {
                    statusMessage = "Failed to get download URL: \(err)"
                    return
                }
                
                self.statusMessage = "Image uploaded successfully"
                
                self.currentImage = newImage
                
                self.newSelectedImage = nil
                
            }
        }
    }
    
    private func signOut(){
        do {
            try FirebaseManager.shared.auth.signOut()
            
            self.shouldGoToLogin = true
        } catch {
            statusMessage = "Failed to sign out"
        }
    }
}


#Preview {
    ProfileView()
}
