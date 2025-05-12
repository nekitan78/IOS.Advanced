//
//  AccountView.swift
//  MakeUpDataBase
//
//  Created by Andryuchshenko Nikita on 28.04.2025.
//

import SwiftUI
import PhotosUI

struct AccountView: View {
    @StateObject var accountViewModel = AccountViewModel()
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImage: UIImage? = nil
    @State private var isDarkMode: Bool = ThemeManager.shared.isDarkMode


    var body: some View {
        ZStack {
            NavigationStack {
                VStack {
                
                    VStack(spacing: 8) {
                        if let photoURL = accountViewModel.authUser?.photoURL{
                            ImageLoader(
                                imageURL: photoURL,
                                width: 100,
                                height: 100,
                                alertItem: $accountViewModel.alertMessage
                            )
                            .clipShape(Circle())
                            .shadow(radius: 4)
                        }else{
                            Circle()
                                .frame(width: 100, height: 100)
                                .foregroundStyle(.gray)
                                .overlay(){
                                    Image(systemName: "person.fill")
                                        .resizable()
                                        .frame(width: 70, height: 70, alignment: .center)
                                }
                            
                            
                        }
                        
                        PhotosPicker(selection: $selectedItem, matching: .images) {
                            Text("Choose Profile Photo")
                        }
                        .onChange(of: selectedItem) {_, newItem in
                            Task {
                                if let data = try? await newItem?.loadTransferable(type: Data.self),
                                   let image = UIImage(data: data) {
                                    print("✅ Image successfully selected from gallery.")
                                    self.selectedImage = image
                                    accountViewModel.uploadAndSetPhoto(image: image)
                                }
                            }
                        }
                    
                        if let name = accountViewModel.authUser?.displayName {
                            Text(name)
                                .font(.headline)
                        }

                        if let email = accountViewModel.authUser?.email {
                            Text(email)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }

                        if let provider = accountViewModel.authUser?.providerID {
                            Text("Signed in with: \(provider.capitalized)")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.top)

                   
                    List {
                        Section(header: Text("Preferences")) {
                            HStack {
                                Text("Dark Mode")
                                Spacer()
                                Toggle("", isOn: $isDarkMode)
                                    .labelsHidden()
                                    .onChange(of: isDarkMode) { _, newValue in
                                        withAnimation(.easeInOut(duration: ThemeManager.shared.transitionDuration)) {
                                            ThemeManager.shared.isDarkMode = newValue
                                        }
                                    }
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: ThemeManager.shared.transitionDuration)) {
                                    ThemeManager.shared.toggleTheme()
                                    isDarkMode.toggle()
                                }
                            }
                        }
                        .themeTransition()

                        Section {
                            Button(role: .destructive) {
                                Task {
                                    accountViewModel.LogOut()
                                    if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                                       let sceneDelegate = scene.delegate as? SceneDelegate {
                                        sceneDelegate.backToAuth()
                                    }
                                }
                            } label: {
                                Text("Log Out")
                            }
                        }
                    }
                }
                .navigationTitle("Account")
            }
            if accountViewModel.isLoading{
                LoadingView()
            }
        }
        .onAppear {
            Task {
                await accountViewModel.fetchUser()
            }
            isDarkMode = ThemeManager.shared.isDarkMode
        }
        .alert(item: $accountViewModel.alertMessage) { alert in
            Alert(title: alert.title, message: alert.message, dismissButton: alert.dismissButton)
        }
        
        
    }
}

#Preview {
    AccountView()
}
