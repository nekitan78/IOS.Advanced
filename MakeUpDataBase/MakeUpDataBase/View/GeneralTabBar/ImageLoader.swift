//
//  ImageLoader.swift
//  MakeUpDataBase
//
//  Created by Andryuchshenko Nikita on 21.04.2025.
//

import Foundation
import SwiftUI

struct ImageLoader: View {
    let imageURL: String
    let width: CGFloat
    let height: CGFloat
    @Binding var isLoading: Bool
    @Binding var alertItem: AlertItem?
    
    var body: some View {
        AsyncImage(url: URL(string: imageURL)){phase in
            switch(phase){
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: width, height: height)
                    .cornerRadius(8)
                    .onAppear { isLoading = false }
            case .empty:
                Rectangle()
                    .frame(width: width, height: height)
                    .foregroundColor(Color(.gray))
                    .cornerRadius(8)
                    .onAppear { isLoading = true }
            case .failure(_):
                Rectangle()
                    .frame(width: width, height: height)
                    .foregroundColor(Color(.yellow))
                    .cornerRadius(8)
                    .onAppear {
                        isLoading = false
                        alertItem = ErrorContext.invalidImageURL
                    }
                
            @unknown default:
                Rectangle()
                    .frame(width: width, height: height)
                    .foregroundColor(Color(.red))
                    .cornerRadius(8)
                    .onAppear { isLoading = false }
            }
                        
        }

    }
}

