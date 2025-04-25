//
//  FavouritesView.swift
//  MakeUpDataBase
//
//  Created by Andryuchshenko Nikita on 24.04.2025.
//

import SwiftUI

struct FavouritesView: View {
    
    
    @EnvironmentObject var favoriteProducts: favoritesEnviroment
    
    
    var body: some View {
        NavigationStack{
            ZStack{
                HStack{
                    List(){
                        ForEach(favoriteProducts.favorites){product in
                            ListCell(imageURL: product.image_url, name: product.name, price: product.price)
                            
                        }
                        .onDelete(perform: ){IndexSet in
                            favoriteProducts.favorites.remove(atOffsets: IndexSet)
                        }
                    }
                    .listStyle(.plain)
                }
                if favoriteProducts.favorites.isEmpty{
                    EmptyState()
                }
            }
            .navigationTitle("Favourites")
        }
        
    }
}

#Preview {
    FavouritesView()
        .environmentObject(favoritesEnviroment())
}
