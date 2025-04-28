//
//  AuthentificationViewModel.swift
//  MakeUpDataBase
//
//  Created by Andryuchshenko Nikita on 27.04.2025.
//

import Foundation
import GoogleSignIn
import GoogleSignInSwift
import SwiftUI
import FirebaseAuth

@MainActor
final class AuthentificationViewModel:ObservableObject{
    func googleSignIn()async throws{
        
        guard let topVC = Utilities.shared.topViewController() else{
            throw URLError(.cannotFindHost)
        }
        
        let signInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)
        
        guard let idToken = signInResult.user.idToken?.tokenString else{
            throw URLError(.badServerResponse)
        }
        let accessToken = signInResult.user.accessToken.tokenString
        
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        try await AuthenticationManager.shared.signInWithGoogle(credential: credential)

    }
}
