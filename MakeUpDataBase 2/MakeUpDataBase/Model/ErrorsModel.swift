//
//  ErrorsModel.swift
//  MakeUpDataBase
//
//  Created by Andryuchshenko Nikita on 26.04.2025.
//

import Foundation
import SwiftUI

struct AlertItem: Identifiable{
    let id = UUID()
    let title : Text
    let message : Text
    let dismissButton: Alert.Button
}

struct ErrorContext{
    static let invalidURL = AlertItem(title: Text("invalid Json URL"),
                               message: Text("Something is wrong with Json URL"),
                               dismissButton: .default(Text("Ok"))
    )
    
    static let decodingFailed = AlertItem(title: Text("decoding Failure"),
                                   message: Text("Something happened during decoding"),
                                   dismissButton: .default(Text("Ok"))
    )
    
    static let invalidImageURL = AlertItem(title: Text("Invalid Image URL"),
                                   message: Text("Something is happened with image url, check if it is correct"),
                                   dismissButton: .default(Text("Ok"))
    )
    
    static let logOutError = AlertItem(title: Text("Cant Log out"),
                                   message: Text("Something is wrong, we cant log out"),
                                   dismissButton: .default(Text("Ok"))
    )
    
    static let logInError = AlertItem(title: Text("Cant Log in"),
                                   message: Text("Something is wrong, we cant log in"),
                                   dismissButton: .default(Text("Ok"))
    )
    
    static let signUpError = AlertItem(title: Text("Cant Sign up"),
                                   message: Text("Something is wrong, we cant sign up"),
                                   dismissButton: .default(Text("Ok"))
    )
    
    
    static let fetchUserError = AlertItem(title: Text("Cant fetch user"),
                                   message: Text("Failed to fetch a user try later"),
                                   dismissButton: .default(Text("Ok"))
    )
    
    static let errorInTopController = AlertItem(title: Text("Cant find top controller"),
                                   message: Text("Failed to find top controller try later"),
                                   dismissButton: .default(Text("Ok"))
    )
    
    static let idTokenError = AlertItem(title: Text("Id Token Problem"),
                                   message: Text("Something is wrong with id token"),
                                   dismissButton: .default(Text("Ok"))
    )
    
    static let emailPasswordError = AlertItem(title: Text("Wrong data"),
                                   message: Text("Email or password fiels are empty"),
                                   dismissButton: .default(Text("Ok"))
    )
    
    static let IdError = AlertItem(title: Text("Error"),
                                   message: Text("Failed to get user ID. Please log out and log back in."),
                                   dismissButton: .default(Text("Ok"))
                                    
    )
    
    static let ImageError = AlertItem(title: Text("Image Error"),
                                   message: Text("Failed to process the selected image."),
                                   dismissButton: .default(Text("Ok"))
                                    
    )
    
    static let uploadError = AlertItem(title: Text("Upload Error"),
                                       message: Text("Somethin happend during uploading"),
                                       dismissButton: .default(Text("Ok"))
                                    
    )
    
    static let downloadUrlError = AlertItem(title: Text("URL Error"),
                                            message: Text("Failed to get download URL"),
                                            dismissButton: .default(Text("Ok"))
                                    
    )
    
    static let dataBaseError = AlertItem(title: Text("Database Error"),
                                         message: Text("Database error occured, something happend with the database"),
                                         dismissButton: .default(Text("Ok"))
                                    
    )
    
    static let profileUpdateError = AlertItem(title: Text("Profile Update Error"),
                                              message: Text("Couldnt update profile"),
                                              dismissButton: .default(Text("Ok"))
                                    
    )
    
    static let productError = AlertItem(title: Text("Product error"),
                                              message: Text("Couldnt find a product"),
                                              dismissButton: .default(Text("Ok"))
                                    
    )
}

