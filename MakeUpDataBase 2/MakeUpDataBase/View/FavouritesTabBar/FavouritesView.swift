//
//  FavouritesView.swift
//  MakeUpDataBase
//
//  Created by Andryuchshenko Nikita on 24.04.2025.
//

import SwiftUI

struct FavouritesView: View {
    
    @EnvironmentObject var favoriteProducts: favoritesEnviroment
    @State var selectedProduct: Product?
    let router: FavoriteRouter
    @State var alert: AlertItem?
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    List {
                        ForEach(favoriteProducts.favorites) { product in
                            ListCell(
                                imageURL: product.image_url ?? "",
                                name: product.name ?? "No Name",
                                price: product.price ?? "N/A",
                                alertItem: $alert
                            )
                            .onTapGesture {
                                selectedProduct = product
                                router.gotoDetail(with: selectedProduct ?? MockData.arrayOfProducts[0])
                            }
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                let toRemove = favoriteProducts.favorites[index]
                                favoriteProducts.toggleFavorite(toRemove)
                            }
                        }
                    }
                    .listStyle(.plain)
                }
                .alert(item: $alert) { alert in
                    Alert(title: alert.title, message: alert.message, dismissButton: alert.dismissButton)
                }
                
                if favoriteProducts.favorites.isEmpty {
                    EmptyState()
                }
            }
            .navigationTitle("Favourites")
        }
    }
}

#Preview {
    FavouritesView(router: FavoriteRouter())
        .environmentObject(favoritesEnviroment())
}
