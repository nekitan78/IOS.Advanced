//
//  Favorites.swift
//  MakeUpDataBase
//
//  Created by Andryuchshenko Nikita on 25.04.2025.
//

import Foundation

final class favoritesEnviroment: ObservableObject{
    @Published var favorites: [Product] = []
}
