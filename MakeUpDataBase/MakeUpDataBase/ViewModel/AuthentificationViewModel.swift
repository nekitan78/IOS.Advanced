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
    
    @Published var email:String = ""
    @Published var password: String = ""
    @Published var alertMessage: AlertItem?
    
    func googleSignIn()async throws{
        
        guard let topVC = Utilities.shared.topViewController() else{
            alertMessage = ErrorContext.errorInTopController
            throw URLError(.cannotFindHost)
        }
        
        let signInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)
        
        guard let idToken = signInResult.user.idToken?.tokenString else{
            alertMessage = ErrorContext.idTokenError
            throw URLError(.badServerResponse)
        }
        let accessToken = signInResult.user.accessToken.tokenString
        
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        try await AuthenticationManager.shared.signInWithGoogle(credential: credential)

    }
    
    func signUp() async throws -> Bool{
        guard !email.isEmpty, !password.isEmpty else{
            print("No email or password provided!")
            alertMessage = ErrorContext.emailPasswordError
            return false
        }
        
        do{
            try await AuthenticationManager.shared.createUser(email: email, password: password)
            print("Account created")
            return true
        }catch{
            print("Firebase sign-up error: \(error.localizedDescription)")
            alertMessage = ErrorContext.signUpError
            return false
        }
        
        
    }
    
    func signIn() async throws -> Bool{
        guard !email.isEmpty, !password.isEmpty else{
            print("No email or password provided!")
            alertMessage = ErrorContext.emailPasswordError
            return false
        }
        do{
            let _ = try await AuthenticationManager.shared.logIn(email: email, password: password)
            return true
        }catch{
            alertMessage = ErrorContext.logInError
            return false
        }
        
    }
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
