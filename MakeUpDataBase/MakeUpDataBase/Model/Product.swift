//
//  Product.swift
//  MakeUpDataBase
//
//  Created by Andryuchshenko Nikita on 21.04.2025.
//


struct Product:Decodable, Identifiable{
    let id: Int
    let brand: String
    let name: String
    let image_url: String
    let price: String
    let rating: String?
    let description: String
    let how_to_use: String
    let benefits: String
    let full_ingredient_list: String?
    let sustainability: [String]
}
