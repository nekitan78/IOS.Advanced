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
    func LogOut(){
        do{
            try AuthenticationManager.shared.LogOut()
        }catch{
            
        }
            
        
    }
}
