//
//  AccountView.swift
//  MakeUpDataBase
//
//  Created by Andryuchshenko Nikita on 28.04.2025.
//

import SwiftUI

struct AccountView: View {
    @StateObject var accountViewModel = AccountViewModel()
    @State var authUser: AuthDataResultModel?
    
    var body: some View {
        ZStack{
            NavigationStack{
                List(){
                    
                    if let email = accountViewModel.authUser?.email {
                        HStack {
                            Text("Email:")
                            Spacer()
                            Text(email)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Button(){
                        Task{
                            accountViewModel.LogOut()
                            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                                let sceneDelegate = scene.delegate as? SceneDelegate {
                                sceneDelegate.backToAuth()
                            }
                        }
                    }label: {
                        Text("Log Out")
                    }
                    
                    
                }
                .navigationTitle("Account")
            }
        }
        .onAppear(){
            accountViewModel.fetchUser()
            
        }
        .alert(item: $accountViewModel.alertMessage){alert in
            Alert(title: alert.title, message: alert.message, dismissButton: alert.dismissButton)
        }
        
    }
}

#Preview {
    AccountView()
}
