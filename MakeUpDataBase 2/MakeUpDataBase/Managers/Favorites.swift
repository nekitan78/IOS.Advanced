//
//  Favorites.swift
//  MakeUpDataBase
//
//  Created by Andryuchshenko Nikita on 25.04.2025.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore


final class favoritesEnviroment: ObservableObject{
    @Published var favorites: [Product] = []
    private var db = Firestore.firestore()
        
        func saveFavoritesToFirestore() {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            let data = favorites.map {$0.toDictionary() }.compactMap { $0 }

            db.collection("users").document(uid).setData(["favorites": data], merge: true) { error in
                if let error = error {
                    print("Error saving favorites: \(error)")
                } else {
                    print("Favorites saved successfully.")
                }
            }
        }

        func loadFavoritesFromFirestore() {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            db.collection("users").document(uid).getDocument { snapshot, error in
                if let error = error {
                    print("Error loading favorites: \(error)")
                    return
                }

                if let data = snapshot?.data(),
                   let rawFavorites = data["favorites"] as? [[String: Any]] {
                    self.favorites = rawFavorites.compactMap {Product(from: $0) }
                }
            }
        }

        func toggleFavorite(_ product: Product) {
            if let index = favorites.firstIndex(where: { $0.id == product.id }) {
                favorites.remove(at: index)
            } else {
                favorites.append(product)
            }
            saveFavoritesToFirestore()
        }
}
