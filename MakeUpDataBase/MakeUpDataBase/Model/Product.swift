//
//  Product.swift
//  MakeUpDataBase
//
//  Created by Andryuchshenko Nikita on 21.04.2025.
//
import Foundation

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
extension Product {
  
  func toDictionary() -> [String: Any] {
    return [
      "id": id,
      "brand": brand,
      "name": name,
      "image_url": image_url,
      "price": price,
      // Firestore can store `nil` if you omit the key rather than store NSNull
      "rating": rating as Any,
      "description": description,
      "how_to_use": how_to_use,
      "benefits": benefits,
      "full_ingredient_list": full_ingredient_list as Any,
      "sustainability": sustainability
    ]
  }

  
  init?(from dict: [String: Any]) {
    guard
      let id          = dict["id"]               as? Int,
      let brand       = dict["brand"]            as? String,
      let name        = dict["name"]             as? String,
      let image_url   = dict["image_url"]        as? String,
      let price       = dict["price"]            as? String,
      let description = dict["description"]      as? String,
      let howToUse    = dict["how_to_use"]       as? String,
      let benefits    = dict["benefits"]         as? String,
      let sustainability = dict["sustainability"] as? [String]
    else {
      return nil
    }

    self.id                   = id
    self.brand                = brand
    self.name                 = name
    self.image_url            = image_url
    self.price                = price
    self.rating               = dict["rating"] as? String
    self.description          = description
    self.how_to_use           = howToUse
    self.benefits             = benefits
    self.full_ingredient_list = dict["full_ingredient_list"] as? String
    self.sustainability       = sustainability
  }
}
