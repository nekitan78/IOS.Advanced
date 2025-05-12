//
//  AccountViewModel.swift
//  MakeUpDataBase
//
//  Created by Andryuchshenko Nikita on 28.04.2025.
//

import Foundation
import SwiftUI
import GoogleSignIn
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

@MainActor
final class AccountViewModel: ObservableObject {
    
    @Published var authUser: AuthDataResultModel?
    @Published var alertMessage: AlertItem?
    @Published var isLoading: Bool = false
    
    init() {
        Task {
            await fetchUser()
        }
    }
    
    func LogOut() {
        do {
            try AuthenticationManager.shared.LogOut()
        } catch {
            alertMessage = ErrorContext.logOutError
        }
    }
    
    func fetchUser() async {
        isLoading = true
        do {
            if let tempAuthUser = try AuthenticationManager.shared.getAuthUser() {
                
                var authUser = tempAuthUser
                
                let snapshot = try await Firestore.firestore().collection("users").document(authUser.uid).getDocument()
                if let data = snapshot.data() {
                    authUser.photoURL = data["photoURL"] as? String
                }
                self.authUser = authUser
            }
            isLoading = false
            
        } catch {
            print("❌ Failed to fetch user: \(error.localizedDescription)")
            alertMessage = ErrorContext.fetchUserError
            self.authUser = nil
            isLoading = false
        }
    }
    
    func uploadAndSetPhoto(image: UIImage) {
        guard let uid = Auth.auth().currentUser?.uid else {
            alertMessage = ErrorContext.IdError
            return
        }
        
        // Convert image to JPEG data
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            alertMessage = ErrorContext.ImageError
            return
        }
        
        print("Starting upload, image size: \(imageData.count / 1024) KB")
        
        let storage = Storage.storage()
        let storageRef = storage.reference().child("profile_images/\(uid)_\(Date().timeIntervalSince1970).jpg")
        
        isLoading = true
        
        // Define metadata to ensure proper content type
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        storageRef.putData(imageData, metadata: metadata) { [weak self] metadata, error in
            guard let self = self else { return }
            
            if error != nil {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.alertMessage = ErrorContext.uploadError
                }
                return
            }
            
            storageRef.downloadURL { [weak self] url, error in
                guard let self = self else { return }
                
                if error != nil {
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.alertMessage = ErrorContext.invalidImageURL
                    }
                    return
                }

                guard let downloadURL = url else {
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.alertMessage = ErrorContext.downloadUrlError
                    }
                    return
                }

                print("✅ Image uploaded successfully. URL: \(downloadURL.absoluteString)")
                
                // Save URL to Firestore
                let db = Firestore.firestore()
                db.collection("users").document(uid).setData(
                    ["photoURL": downloadURL.absoluteString],
                    merge: true
                ) { [weak self] error in
                    guard let self = self else { return }
                    
                    if error != nil {
                        DispatchQueue.main.async {
                            self.isLoading = false
                            self.alertMessage = ErrorContext.dataBaseError
                            
                        }
                        return
                    }
                    
                    // Also update Firebase Auth profile
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.photoURL = downloadURL
                    changeRequest?.commitChanges { [weak self] error in
                        guard let self = self else { return }
                        
                        DispatchQueue.main.async {
                            self.isLoading = false
                            
                            if error != nil {
                                self.alertMessage = ErrorContext.profileUpdateError
                            } else {
                                print("✅ Profile updated successfully")
                                Task {
                                    await self.fetchUser() 
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
