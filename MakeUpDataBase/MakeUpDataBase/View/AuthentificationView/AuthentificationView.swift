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
    
    var body: some View {
        ZStack{
            NavigationStack{
                VStack{
                    
                    TextField("Email", text: $authViewModel.email)
                        .padding()
                        .background(.gray.opacity(0.4))
                        .cornerRadius(10)
                    
                    SecureField("Password", text: $authViewModel.password)
                        .padding()
                        .background(.gray.opacity(0.4))
                        .cornerRadius(10)
                    
                    Button(){
                        Task {
                            do {
                                let success = try await authViewModel.signUp()
                                if success{
                                    if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                                           let sceneDelegate = scene.delegate as? SceneDelegate {
                                            sceneDelegate.switchToMain()
                                    }
                                }
                                return
                            } catch {
                                print("Sign-up error: \(error)")
                            }
                            
                        }
                    }label: {
                        Text("Sign up")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(.blue.opacity(0.5))
                            .foregroundStyle(.white)
                            .cornerRadius(10)
                    }
                    
                    Button(){
                        Task {
                        
                            do {
                                let success = try await authViewModel.signIn()
                                if success {
                                    if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                                           let sceneDelegate = scene.delegate as? SceneDelegate {
                                            sceneDelegate.switchToMain()
                                    }
                                }
                                return
                            } catch {
                                print("Sign-in error: \(error)")
                            }
                        }
                    }label: {
                        Text("Sign in")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(.blue.opacity(0.5))
                            .foregroundStyle(.white)
                            .cornerRadius(10)
                    }

                    
                    GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .dark, style: .wide, state: .normal)){
                        Task{
                            do{
                                try await authViewModel.googleSignIn()
                                            
                                // UI updates should be done on the main thread
                                await MainActor.run {
                                    if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                                           let sceneDelegate = scene.delegate as? SceneDelegate {
                                            sceneDelegate.switchToMain()
                                    }
                                }
                            }catch{
                                print("Sign-in error: \(error)")
                            }
                        }
                    }
                    .padding(10)
                    Spacer()
                }
                .navigationTitle("Sign in")
            }
            .alert(item: $authViewModel.alertMessage){alert in
                Alert(title: alert.title, message: alert.message, dismissButton: alert.dismissButton)
            }
            
        }
    }
}

#Preview {
    AuthentificationView()
}
