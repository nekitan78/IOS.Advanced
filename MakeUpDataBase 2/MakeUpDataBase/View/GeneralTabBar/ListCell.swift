//
//  ListCell.swift
//  MakeUpDataBase
//
//  Created by Andryuchshenko Nikita on 10.05.2025.
//
import SwiftUI

struct ListCell: View {
    let imageURL: String
    let name: String
    let price: String
    @Binding var alertItem: AlertItem?

    var body: some View {
        HStack {
            ImageLoader(imageURL: imageURL, width: 60, height: 60, alertItem: $alertItem)

            VStack(alignment: .leading) {
                Text(name)
                    .font(.headline)
                Text(price)
                    .fontWeight(.light)
            }
            .padding(.leading)
        }
        .padding(.leading)
        .padding(.top)
    }
}
