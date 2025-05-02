//
//  AuthenticationManager.swift
//  MakeUpDataBase
//
//  Created by Andryuchshenko Nikita on 28.04.2025.
//

import Foundation
import SwiftUI
import FirebaseAuth
import GoogleSignIn

struct AuthDataResultModel{
    let uid: String
    let email: String?
    var photoURL: String?
    let providerID: String
    let displayName: String?
    
    init(user: User){
        self.uid = user.uid
        self.email = user.email
        self.photoURL = user.photoURL?.absoluteString
        self.providerID = user.providerData.first?.providerID ?? "unknown"
        self.displayName = user.displayName
    }
}

final class AuthenticationManager{
    static var shared = AuthenticationManager()
    private init () {}
    @discardableResult
    func signInWithGoogle(credential: AuthCredential) async throws -> AuthDataResultModel{
        let authDataResult = try await Auth.auth().signIn(with: credential)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    func getAuthUser() throws-> AuthDataResultModel?{
        guard let user = Auth.auth().currentUser else {
            return nil
        }
        return AuthDataResultModel(user: user)
    }
    
    func LogOut() throws{
        do {
            GIDSignIn.sharedInstance.signOut()
            try Auth.auth().signOut()
        } catch {
            print("Error in log out")
        }
        
    }
    @discardableResult
    func createUser(email: String, password: String) async throws -> AuthDataResultModel{
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    func logIn(email: String, password: String) async throws -> AuthDataResultModel{
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
}
