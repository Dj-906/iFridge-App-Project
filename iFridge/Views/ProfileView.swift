import SwiftUI
import FirebaseStorage
import FirebaseAuth

struct StatefulPreviewWrapper<Value, Content: View>: View {
    @State private var value: Value
    private let content: (Binding<Value>) -> Content

    init(_ initialValue: Value, @ViewBuilder content: @escaping (Binding<Value>) -> Content) {
        self._value = State(initialValue: initialValue)
        self.content = content
    }

    var body: some View {
        content($value)
    }
}

class FirebaseManager: NSObject {
    static let shared = FirebaseManager()
    let auth: Auth
    let storage: Storage
    
    override init() {
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        
        super.init()
    }
}

struct ProfileView: View {
    @Binding var isLoggedIn: Bool
    
    @State private var currentImage: UIImage?
    @State private var newSelectedImage: UIImage?
    @State private var statusMessage: String = ""
    @State private var shouldShowImagePicker: Bool = false
    @State private var shouldGoToLogin = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                // Show user's email
                if let user = FirebaseManager.shared.auth.currentUser {
                    Text("Username: \(user.email ?? "No Email Provided")")
                        .font(.headline)
                } else {
                    Text("No user logged in")
                        .font(.headline)
                }
                
                // Display user's image
                let displayImage = newSelectedImage ?? currentImage
                if let image = displayImage {
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
                
                // Button to select image
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
                
                // Buttons for cancel and upload
                if newSelectedImage != nil {
                    HStack {
                        Button("Cancel") {
                            newSelectedImage = nil
                            statusMessage = "Cancelled new image selection"
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
                
                // Status message
                Text(statusMessage)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding()
                
                Spacer()
                
                // Sign out button
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
                
                // Navigation to LoginView
                NavigationLink(value: shouldGoToLogin) {
                    EmptyView()
                }
                .navigationDestination(isPresented: $shouldGoToLogin) {
                    LoginView(isLoggedIn: .constant(false))
                        .navigationBarBackButtonHidden(true)
                }
                .hidden()
            }
            .padding()
            .navigationTitle(Text("Profile"))
        }
        .onAppear {
            // Additional onAppear logic if needed
        }
        .sheet(isPresented: $shouldShowImagePicker) {
            ImagePicker(image: $newSelectedImage)
        }
    }
    
    // Upload new image to Firebase
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
        
        ref.putData(imageData, metadata: nil) { metadata, err in
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
    
    // Sign out function
    private func signOut() {
        isLoggedIn = false
        
        do {
            try FirebaseManager.shared.auth.signOut()
            self.shouldGoToLogin = true
        } catch {
            statusMessage = "Failed to sign out"
        }
    }
}

#Preview {
    StatefulPreviewWrapper(false) { isLoggedIn in
        ProfileView(isLoggedIn: isLoggedIn)
    }
}
