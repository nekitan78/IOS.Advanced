//
//  FavouritesView.swift
//  MakeUpDataBase
//
//  Created by Andryuchshenko Nikita on 24.04.2025.
//

import SwiftUI

struct FavouritesView: View {
    
    
    @EnvironmentObject var favoriteProducts: favoritesEnviroment
    @State var isLoading: Bool = false
    @State var selectedProduct: Product?
    let router: FavoriteRouter
    @State var alert: AlertItem?
    
    
    var body: some View {
        NavigationStack{
            ZStack{
                VStack{
                    List(){
                        ForEach(favoriteProducts.favorites){product in
                            ListCell(imageURL: product.image_url, name: product.name, price: product.price, isLoading: $isLoading, alertItem: $alert)
                                
                            
                                .onTapGesture {
                                    selectedProduct = product
                                    router.gotoDetail(with: selectedProduct ?? MockData.arrayOfProducts[0])
                                }
                            
                            
                        }
                        .onDelete(perform: ){IndexSet in
                            for idx in IndexSet {
                                let toRemove = favoriteProducts.favorites[idx]
                                favoriteProducts.toggleFavorite(toRemove)
                            }
                                
                        }
                        
                        
                    }
                    .listStyle(.plain)
                    
                }
                .alert(item: $alert){alert in
                    Alert(title: alert.title, message: alert.message, dismissButton: alert.dismissButton)
                }
                if favoriteProducts.favorites.isEmpty{
                    EmptyState()
                }
                if isLoading{
                    LoadingView()
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
