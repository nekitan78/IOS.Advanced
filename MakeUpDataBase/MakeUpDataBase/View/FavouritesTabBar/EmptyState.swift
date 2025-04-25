//
//  EmptyState.swift
//  MakeUpDataBase
//
//  Created by Andryuchshenko Nikita on 24.04.2025.
//

import SwiftUI

struct EmptyState: View {
    var body: some View {
        ZStack{
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack{
                Image(systemName: "star.slash")
                    .resizable()
                    .renderingMode(.original)
                    .scaledToFit()
                    .frame(height: 150)
                
                Text("You have no items in your favourites. \nPlease choose a product")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                    .padding()
            }
            .offset(y: -80)
        }
    }
}

#Preview {
    EmptyState()
}
