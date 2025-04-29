//
//  AccountViewModel.swift
//  MakeUpDataBase
//
//  Created by Andryuchshenko Nikita on 28.04.2025.
//

import Foundation
import SwiftUI
import GoogleSignIn

final class AccountViewModel:ObservableObject{
    
    @Published var authUser: AuthDataResultModel?
    @Published var alertMessage: AlertItem?
    
    init() {
        fetchUser()
    }
    
    func LogOut(){
        do{
            try AuthenticationManager.shared.LogOut()
        }catch{
            alertMessage = ErrorContext.logOutError
        }
    }
    
    func fetchUser(){
        do {
            self.authUser = try AuthenticationManager.shared.getAuthUser()
        } catch {
            alertMessage = ErrorContext.fetchUserError
            self.authUser = nil
        }
    }
}
