//
//  AuthentificationView.swift
//  MakeUpDataBase
//
//  Created by Andryuchshenko Nikita on 18.04.2025.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

struct AuthentificationView: View {
    @StateObject var authViewModel = AuthentificationViewModel()
    @Binding var isShowSignIn: Bool
    var body: some View {
        NavigationStack{
            VStack{
                GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .dark, style: .wide, state: .normal)){
                    Task{
                        do{
                            try await authViewModel.googleSignIn()
                            isShowSignIn = false
                        }catch{
                            
                        }
                    }
                }
                .padding(10)
                Spacer()
            }
            .navigationTitle("Sign in")
        }
    }
}

#Preview {
    AuthentificationView(isShowSignIn: .constant(false))
}
