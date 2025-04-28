//
//  AccountView.swift
//  MakeUpDataBase
//
//  Created by Andryuchshenko Nikita on 28.04.2025.
//

import SwiftUI

struct AccountView: View {
    @StateObject var accountViewModel = AccountViewModel()
    @State var isShowSignIn: Bool = false
    var body: some View {
        ZStack{
            NavigationStack{
                List(){
                    Button(){
                        Task{
                            accountViewModel.LogOut()
                            isShowSignIn = true
                        }
                    }label: {
                        Text("Log Out")
                    }
                }
                .navigationTitle("Account")
            }
        }
        .fullScreenCover(isPresented: $isShowSignIn){
            AuthentificationView(isShowSignIn: $isShowSignIn )
        }
    }
}

#Preview {
    AccountView()
}
