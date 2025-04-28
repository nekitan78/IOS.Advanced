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
                                   message: Text("Something is happened with imgae url, check if it is correct"),
                                   dismissButton: .default(Text("Ok"))
    )
    
    
}
