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
    let photoURL: String?
    
    init(user: User){
        self.uid = user.uid
        self.email = user.email
        self.photoURL = user.photoURL?.absoluteString
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
    
    func getAuthUser()throws -> AuthDataResultModel{
        guard let user = Auth.auth().currentUser else {
            throw NSError(domain: "User not found", code: 0, userInfo: nil)
        }
        return AuthDataResultModel(user: user)
    }
    
    func LogOut() throws{
        try Auth.auth().signOut()
        GIDSignIn.sharedInstance.signOut()
    }
}
